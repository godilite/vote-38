import 'dart:typed_data';
import 'dart:ui';

import 'package:dice_bear/dice_bear.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/services/post_service.dart';
import 'package:vote38/src/services/secure_storage.dart';
import 'package:vote38/src/services/token_service.dart';

part 'create_post_view_model.g.dart';

enum PostState {
  initial,
  loading,
  success,
  error,
}

class CreatePostViewModel = _CreatePostViewModel with _$CreatePostViewModel;

abstract class _CreatePostViewModel with Store {
  final PostService _postService;
  final AssetServiceImpl _tokenService;
  final SecureStorage _secureStorage;

  _CreatePostViewModel(this._postService, this._tokenService, this._secureStorage);

  @observable
  ObservableMap<String, ObservableList<Observable<AccountEntryDataInput>>> options = ObservableMap();

  @observable
  PostState postState = PostState.initial;

  @observable
  String question = '';

  @observable
  String webLink = '';

  @observable
  String videoLink = '';

  @observable
  String imageLink = '';

  @observable
  String limit = '';

  @observable
  String code = '';

  @observable
  String issuerId = ''; // issuer account id for NFT

  Stream<Uint8List> imageStream = const Stream.empty();

  @observable
  Image? image;

  @observable
  String? error;

  @observable
  String postAccountSeed = '';

  @observable
  String issuerAccountSeed = '';

  @observable
  String nftName = '';

  @observable
  FilePickerResult? filePickerResult;

  @observable
  String cid = '';

  @computed
  bool get canAddNft => nftName.isNotEmpty && code.isNotEmpty && limit.isNotEmpty && image != null;

  @observable
  bool isNftLoading = false;

  @observable
  bool isNftEdited = false;

  @computed
  bool get canSubmit =>
      question.isNotEmpty &&
      limit.isNotEmpty &&
      code.isNotEmpty &&
      issuerId.isNotEmpty &&
      postAccountSeed.isNotEmpty &&
      nftName.isNotEmpty &&
      image != null;

  @action
  Future<void> init() async {
    error = null;
    if (issuerId.isEmpty) {
      final accountOwnerId = await _secureStorage.read(SecureStorage.testAccountIDKey);
      final accountOwnerSeed = await _secureStorage.read(SecureStorage.testAccountSecretKey);

      issuerId = accountOwnerId!;
      issuerAccountSeed = accountOwnerSeed!;
      generatePostAccountSeed();
      generateOptionAccountSeed();
      await getCanvasImageAsBytes();
    }
    reaction((_) => [nftName, code, limit, image], (_) {
      isNftEdited = true;
    });
  }

  @action
  Future<void> submitPost() async {
    postState = PostState.loading;
    if (image == null) {
      error = 'nftimagerequired';
      postState = PostState.error;
      return;
    }
    if (question.isNotEmpty &&
        limit.isNotEmpty &&
        code.isNotEmpty &&
        issuerId.isNotEmpty &&
        postAccountSeed.isNotEmpty &&
        nftName.isNotEmpty &&
        cid.isNotEmpty &&
        image != null) {
      try {
        final postAccount = await _postService.createAccount(issuerAccountSeed, postAccountSeed, true);
        // mint NFT
        final success = await _tokenService.mintNFT(code, cid, issuerAccountSeed, postAccount.accountSecretSeed, limit);

        if (!success) {
          error = 'Error minting NFT';
        }
        // create options accounts
        final optionSeeds = options.keys.toList();

        for (final seed in optionSeeds) {
          await _postService.createAccount(postAccountSeed, seed, false);
        }

        await _postService.setTrustlines(optionSeeds, code, issuerId, limit);

        final postData = [
          AccountEntryDataInput('question', question),
          if (webLink.isNotEmpty) AccountEntryDataInput('webLink', webLink),
          if (videoLink.isNotEmpty) AccountEntryDataInput('videoLink', videoLink),
          if (imageLink.isNotEmpty) AccountEntryDataInput('imageLink', imageLink),
          AccountEntryDataInput('createdAt', DateTime.now().toIso8601String()),
          AccountEntryDataInput('nftCid', cid),
        ];

        await _postService.storeInLocalStorage(postAccountSeed);
        final Map<String, List<AccountEntryDataInput>> optionsAndData = {};
        for (final entry in options.entries) {
          optionsAndData[entry.key] = entry.value.map((e) => e.value).toList();
        }

        await _postService.saveToRemoteStorage(
          postAccountSeed,
          limit,
          code,
          issuerId,
          postData,
          optionsAndData,
        );
        dispose();
      } catch (e) {
        if (e is CreateAccountException) {
          error = e.message;
        } else if (e is ManageDataException) {
          error = e.toString();
        } else {
          error = e.toString();
        }
        debugPrint(error);
      } finally {
        postState = error == null ? PostState.success : PostState.error;
      }
    } else {
      error = 'All fields are required';
      postState = PostState.error;
    }
  }

  Future<bool> uploadNft() async {
    error = null;
    isNftLoading = true;
    // upload image to IPFS and get the CID
    try {
      cid = await _tokenService.createNFT(code, issuerAccountSeed, nftName, question, imageStream);
      isNftEdited = false;
    } catch (e) {
      error = 'Error uploading NFT';
    }
    isNftLoading = false;
    return error == null;
  }

  void generatePostAccountSeed() {
    final kp = _postService.createKeyPair();

    postAccountSeed = kp.secretSeed;
  }

  @action
  String generateOptionAccountSeed() {
    final kp = _postService.createKeyPair();

    options[kp.secretSeed] = ObservableList();

    options[kp.secretSeed]!.add(Observable(AccountEntryDataInput('name', 'Option name')));

    return kp.secretSeed;
  }

  @action
  Future<void> updateOrAddAccountData(String secretSeed, String key, String value) async {
    final data = options[secretSeed];
    if (key.isEmpty || value.isEmpty) {
      return;
    }

    if (data != null) {
      final index = data.indexWhere((element) => element.value.key == key);

      if (index != -1) {
        data[index] = Observable(AccountEntryDataInput(key, value));
      } else {
        data.add(Observable(AccountEntryDataInput(key, value)));
      }
    }
  }

  @action
  Future<void> deleteOptionProperty(String secretSeed, String key) async {
    final data = options[secretSeed];

    if (data != null) {
      final index = data.indexWhere((element) => element.value.key == key);

      if (index != -1) {
        data.removeAt(index);
      }
    }
  }

  @action
  Future<void> deleteOption(String secretSeed) async {
    options.remove(secretSeed);
  }

  @action
  Future<void> pickNftFileFromGallery() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      final bytes = result.files.single.bytes;

      if (bytes != null) {
        imageStream = getCanvasImageAsStream(Uint8List.fromList(bytes));
        image = Image.memory(Uint8List.view(bytes.buffer));
      }
    }
  }

  Future<void> getCanvasImageAsBytes() async {
    final avatar = DiceBearBuilder(seed: postAccountSeed, sprite: DiceBearSprite.croodles).build();
    final data = await svgToPng(avatar.svgUri.toString());
    final uint = Uint8List.view(data.buffer);

    imageStream = getCanvasImageAsStream(uint);

    image = Image.memory(uint);
  }

  Future<Uint8List> svgToPng(String url) async {
    final pictureInfo = SvgPicture.network(
      url,
      fit: BoxFit.cover,
      placeholderBuilder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final loader = pictureInfo.bytesLoader;

    final info = await vg.loadPicture(loader, null);

    final image = info.picture.toImageSync(300, 250);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Unable to convert SVG to PNG');
    }

    final pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  Stream<Uint8List> getCanvasImageAsStream(Uint8List bytes) async* {
    yield bytes;
  }

  void dispose() {
    options.clear();
    postState = PostState.initial;
    question = '';
    webLink = '';
    videoLink = '';
    imageLink = '';
    limit = '';
    code = '';
    issuerId = '';
    image = null;
    error = null;
    postAccountSeed = '';
    issuerAccountSeed = '';
    nftName = '';
    filePickerResult = null;
  }
}
