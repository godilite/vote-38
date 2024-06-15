// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePostViewModel on _CreatePostViewModel, Store {
  Computed<bool>? _$canAddNftComputed;

  @override
  bool get canAddNft =>
      (_$canAddNftComputed ??= Computed<bool>(() => super.canAddNft,
              name: '_CreatePostViewModel.canAddNft'))
          .value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_CreatePostViewModel.canSubmit'))
          .value;

  late final _$optionsAtom =
      Atom(name: '_CreatePostViewModel.options', context: context);

  @override
  ObservableMap<String, ObservableList<Observable<AccountEntryDataInput>>>
      get options {
    _$optionsAtom.reportRead();
    return super.options;
  }

  @override
  set options(
      ObservableMap<String, ObservableList<Observable<AccountEntryDataInput>>>
          value) {
    _$optionsAtom.reportWrite(value, super.options, () {
      super.options = value;
    });
  }

  late final _$postStateAtom =
      Atom(name: '_CreatePostViewModel.postState', context: context);

  @override
  PostState get postState {
    _$postStateAtom.reportRead();
    return super.postState;
  }

  @override
  set postState(PostState value) {
    _$postStateAtom.reportWrite(value, super.postState, () {
      super.postState = value;
    });
  }

  late final _$questionAtom =
      Atom(name: '_CreatePostViewModel.question', context: context);

  @override
  String get question {
    _$questionAtom.reportRead();
    return super.question;
  }

  @override
  set question(String value) {
    _$questionAtom.reportWrite(value, super.question, () {
      super.question = value;
    });
  }

  late final _$webLinkAtom =
      Atom(name: '_CreatePostViewModel.webLink', context: context);

  @override
  String get webLink {
    _$webLinkAtom.reportRead();
    return super.webLink;
  }

  @override
  set webLink(String value) {
    _$webLinkAtom.reportWrite(value, super.webLink, () {
      super.webLink = value;
    });
  }

  late final _$videoLinkAtom =
      Atom(name: '_CreatePostViewModel.videoLink', context: context);

  @override
  String get videoLink {
    _$videoLinkAtom.reportRead();
    return super.videoLink;
  }

  @override
  set videoLink(String value) {
    _$videoLinkAtom.reportWrite(value, super.videoLink, () {
      super.videoLink = value;
    });
  }

  late final _$imageLinkAtom =
      Atom(name: '_CreatePostViewModel.imageLink', context: context);

  @override
  String get imageLink {
    _$imageLinkAtom.reportRead();
    return super.imageLink;
  }

  @override
  set imageLink(String value) {
    _$imageLinkAtom.reportWrite(value, super.imageLink, () {
      super.imageLink = value;
    });
  }

  late final _$limitAtom =
      Atom(name: '_CreatePostViewModel.limit', context: context);

  @override
  String get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(String value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  late final _$codeAtom =
      Atom(name: '_CreatePostViewModel.code', context: context);

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  late final _$issuerIdAtom =
      Atom(name: '_CreatePostViewModel.issuerId', context: context);

  @override
  String get issuerId {
    _$issuerIdAtom.reportRead();
    return super.issuerId;
  }

  @override
  set issuerId(String value) {
    _$issuerIdAtom.reportWrite(value, super.issuerId, () {
      super.issuerId = value;
    });
  }

  late final _$imageAtom =
      Atom(name: '_CreatePostViewModel.image', context: context);

  @override
  Image? get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(Image? value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_CreatePostViewModel.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$postAccountSeedAtom =
      Atom(name: '_CreatePostViewModel.postAccountSeed', context: context);

  @override
  String get postAccountSeed {
    _$postAccountSeedAtom.reportRead();
    return super.postAccountSeed;
  }

  @override
  set postAccountSeed(String value) {
    _$postAccountSeedAtom.reportWrite(value, super.postAccountSeed, () {
      super.postAccountSeed = value;
    });
  }

  late final _$issuerAccountSeedAtom =
      Atom(name: '_CreatePostViewModel.issuerAccountSeed', context: context);

  @override
  String get issuerAccountSeed {
    _$issuerAccountSeedAtom.reportRead();
    return super.issuerAccountSeed;
  }

  @override
  set issuerAccountSeed(String value) {
    _$issuerAccountSeedAtom.reportWrite(value, super.issuerAccountSeed, () {
      super.issuerAccountSeed = value;
    });
  }

  late final _$nftNameAtom =
      Atom(name: '_CreatePostViewModel.nftName', context: context);

  @override
  String get nftName {
    _$nftNameAtom.reportRead();
    return super.nftName;
  }

  @override
  set nftName(String value) {
    _$nftNameAtom.reportWrite(value, super.nftName, () {
      super.nftName = value;
    });
  }

  late final _$filePickerResultAtom =
      Atom(name: '_CreatePostViewModel.filePickerResult', context: context);

  @override
  FilePickerResult? get filePickerResult {
    _$filePickerResultAtom.reportRead();
    return super.filePickerResult;
  }

  @override
  set filePickerResult(FilePickerResult? value) {
    _$filePickerResultAtom.reportWrite(value, super.filePickerResult, () {
      super.filePickerResult = value;
    });
  }

  late final _$cidAtom =
      Atom(name: '_CreatePostViewModel.cid', context: context);

  @override
  String get cid {
    _$cidAtom.reportRead();
    return super.cid;
  }

  @override
  set cid(String value) {
    _$cidAtom.reportWrite(value, super.cid, () {
      super.cid = value;
    });
  }

  late final _$isNftLoadingAtom =
      Atom(name: '_CreatePostViewModel.isNftLoading', context: context);

  @override
  bool get isNftLoading {
    _$isNftLoadingAtom.reportRead();
    return super.isNftLoading;
  }

  @override
  set isNftLoading(bool value) {
    _$isNftLoadingAtom.reportWrite(value, super.isNftLoading, () {
      super.isNftLoading = value;
    });
  }

  late final _$isNftEditedAtom =
      Atom(name: '_CreatePostViewModel.isNftEdited', context: context);

  @override
  bool get isNftEdited {
    _$isNftEditedAtom.reportRead();
    return super.isNftEdited;
  }

  @override
  set isNftEdited(bool value) {
    _$isNftEditedAtom.reportWrite(value, super.isNftEdited, () {
      super.isNftEdited = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_CreatePostViewModel.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$submitPostAsyncAction =
      AsyncAction('_CreatePostViewModel.submitPost', context: context);

  @override
  Future<void> submitPost() {
    return _$submitPostAsyncAction.run(() => super.submitPost());
  }

  late final _$updateOrAddAccountDataAsyncAction = AsyncAction(
      '_CreatePostViewModel.updateOrAddAccountData',
      context: context);

  @override
  Future<void> updateOrAddAccountData(
      String secretSeed, String key, String value) {
    return _$updateOrAddAccountDataAsyncAction
        .run(() => super.updateOrAddAccountData(secretSeed, key, value));
  }

  late final _$deleteOptionPropertyAsyncAction = AsyncAction(
      '_CreatePostViewModel.deleteOptionProperty',
      context: context);

  @override
  Future<void> deleteOptionProperty(String secretSeed, String key) {
    return _$deleteOptionPropertyAsyncAction
        .run(() => super.deleteOptionProperty(secretSeed, key));
  }

  late final _$deleteOptionAsyncAction =
      AsyncAction('_CreatePostViewModel.deleteOption', context: context);

  @override
  Future<void> deleteOption(String secretSeed) {
    return _$deleteOptionAsyncAction.run(() => super.deleteOption(secretSeed));
  }

  late final _$pickNftFileFromGalleryAsyncAction = AsyncAction(
      '_CreatePostViewModel.pickNftFileFromGallery',
      context: context);

  @override
  Future<void> pickNftFileFromGallery() {
    return _$pickNftFileFromGalleryAsyncAction
        .run(() => super.pickNftFileFromGallery());
  }

  late final _$_CreatePostViewModelActionController =
      ActionController(name: '_CreatePostViewModel', context: context);

  @override
  String generateOptionAccountSeed() {
    final _$actionInfo = _$_CreatePostViewModelActionController.startAction(
        name: '_CreatePostViewModel.generateOptionAccountSeed');
    try {
      return super.generateOptionAccountSeed();
    } finally {
      _$_CreatePostViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
options: ${options},
postState: ${postState},
question: ${question},
webLink: ${webLink},
videoLink: ${videoLink},
imageLink: ${imageLink},
limit: ${limit},
code: ${code},
issuerId: ${issuerId},
image: ${image},
error: ${error},
postAccountSeed: ${postAccountSeed},
issuerAccountSeed: ${issuerAccountSeed},
nftName: ${nftName},
filePickerResult: ${filePickerResult},
cid: ${cid},
isNftLoading: ${isNftLoading},
isNftEdited: ${isNftEdited},
canAddNft: ${canAddNft},
canSubmit: ${canSubmit}
    ''';
  }
}
