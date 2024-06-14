import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/services/post_service.dart';
import 'package:vote38/src/services/secure_storage.dart';
import 'package:vote38/src/services/token_service.dart';

part 'create_post_view_model.g.dart';

class CreatePostViewModel = _CreatePostViewModel with _$CreatePostViewModel;

abstract class _CreatePostViewModel with Store {
  final PostService _postService;
  final AssetServiceImpl _tokenService;
  final SecureStorage _secureStorage;

  _CreatePostViewModel(this._postService, this._tokenService, this._secureStorage);

  @observable
  ObservableMap<String, ObservableList<Observable<AccountEntryDataInput>>> options = ObservableMap();

  @observable
  bool isLoading = false;

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
    }
    reaction((_) => nftName, (_) {
      if (nftName.isNotEmpty && filePickerResult == null) {
        getCanvasImageAsBytes(nftName);
      } else if (nftName.isEmpty && filePickerResult == null) {
        image = null;
      }
    });
  }

  @action
  Future<void> submitPost() async {
    isLoading = true;
    if (image == null) {
      error = 'nftimagerequired';
      isLoading = false;
      return;
    }
    if (canSubmit) {
      try {
        final postAccount = await _postService.createAccount(issuerAccountSeed, postAccountSeed, true);
        // upload image to IPFS and get the CID
        final cid = await _tokenService.createNFT(code, issuerAccountSeed, nftName, question, imageStream);
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

        // save post data
        for (final entry in options.entries) {
          final seed = entry.key;
          final data = entry.value.map((e) => e.value).toList();

          await _postService.saveAccountData(seed, data);
        }

        final postData = [
          AccountEntryDataInput('question', question),
          if (webLink.isNotEmpty) AccountEntryDataInput('webLink', webLink),
          if (videoLink.isNotEmpty) AccountEntryDataInput('videoLink', videoLink),
          if (imageLink.isNotEmpty) AccountEntryDataInput('imageLink', imageLink),
          AccountEntryDataInput('createdAt', DateTime.now().toIso8601String()),
          AccountEntryDataInput('nftCid', cid),
        ];

        await _postService.saveAccountData(postAccountSeed, postData);

        await _postService.storeInLocalStorage(postAccountSeed);

        await _postService.saveToRemoteStorage(postAccountSeed, limit, code, issuerId, postData);
      } catch (e) {
        error = e.toString();
        debugPrint(error);
      } finally {
        isLoading = false;
      }
    }
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

  Future<void> getCanvasImageAsBytes(String str) async {
    final textStyle = ui.TextStyle(
      fontSize: 40.0,
      foreground: Paint()
        ..shader = ui.Gradient.sweep(
          const Offset(100, 100),
          const <Color>[
            Colors.blue,
            Colors.red,
            Colors.green,
            Colors.blue,
          ],
          const <double>[0.0, 0.3, 0.6, 1.0],
        ),
      fontWeight: FontWeight.w700,
      textBaseline: TextBaseline.alphabetic,
    );
    final paragraphStyle = ui.ParagraphStyle(
      fontStyle: ui.FontStyle.normal,
      fontFamily: 'RubikGlitchPop',
      textAlign: TextAlign.center,
    );

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('$str NFT (◑‿◐)');

    final paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 200));

    final recorder = ui.PictureRecorder();
    final newCanvas = ui.Canvas(recorder);
    newCanvas.drawColor(Colors.white, BlendMode.src);
    newCanvas.drawParagraph(paragraph, const Offset(0, 10));

    final picture = recorder.endRecording();
    final res = await picture.toImage(200, 200);
    final ByteData? data = await res.toByteData(format: ui.ImageByteFormat.png);

    if (data != null) {
      final uint = Uint8List.view(data.buffer);

      imageStream = getCanvasImageAsStream(uint);

      image = Image.memory(uint);
    }
  }

  Stream<Uint8List> getCanvasImageAsStream(Uint8List bytes) async* {
    yield bytes;
  }
}
