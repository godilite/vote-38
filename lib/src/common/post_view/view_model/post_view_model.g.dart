// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostViewModel on _PostViewModel, Store {
  late final _$totalVotesAtom =
      Atom(name: '_PostViewModel.totalVotes', context: context);

  @override
  double get totalVotes {
    _$totalVotesAtom.reportRead();
    return super.totalVotes;
  }

  @override
  set totalVotes(double value) {
    _$totalVotesAtom.reportWrite(value, super.totalVotes, () {
      super.totalVotes = value;
    });
  }

  late final _$nftMetaAtom =
      Atom(name: '_PostViewModel.nftMeta', context: context);

  @override
  NftMeta? get nftMeta {
    _$nftMetaAtom.reportRead();
    return super.nftMeta;
  }

  @override
  set nftMeta(NftMeta? value) {
    _$nftMetaAtom.reportWrite(value, super.nftMeta, () {
      super.nftMeta = value;
    });
  }

  late final _$rowsAtom = Atom(name: '_PostViewModel.rows', context: context);

  @override
  List<OptionData> get rows {
    _$rowsAtom.reportRead();
    return super.rows;
  }

  @override
  set rows(List<OptionData> value) {
    _$rowsAtom.reportWrite(value, super.rows, () {
      super.rows = value;
    });
  }

  late final _$voteStatusAtom =
      Atom(name: '_PostViewModel.voteStatus', context: context);

  @override
  VoteStatus get voteStatus {
    _$voteStatusAtom.reportRead();
    return super.voteStatus;
  }

  @override
  set voteStatus(VoteStatus value) {
    _$voteStatusAtom.reportWrite(value, super.voteStatus, () {
      super.voteStatus = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_PostViewModel.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isSelectAllAtom =
      Atom(name: '_PostViewModel.isSelectAll', context: context);

  @override
  bool get isSelectAll {
    _$isSelectAllAtom.reportRead();
    return super.isSelectAll;
  }

  @override
  set isSelectAll(bool value) {
    _$isSelectAllAtom.reportWrite(value, super.isSelectAll, () {
      super.isSelectAll = value;
    });
  }

  late final _$requestsToVoteAtom =
      Atom(name: '_PostViewModel.requestsToVote', context: context);

  @override
  ObservableList<VotingRequestData> get requestsToVote {
    _$requestsToVoteAtom.reportRead();
    return super.requestsToVote;
  }

  @override
  set requestsToVote(ObservableList<VotingRequestData> value) {
    _$requestsToVoteAtom.reportWrite(value, super.requestsToVote, () {
      super.requestsToVote = value;
    });
  }

  late final _$selectedOptionsAtom =
      Atom(name: '_PostViewModel.selectedOptions', context: context);

  @override
  ObservableList<String> get selectedOptions {
    _$selectedOptionsAtom.reportRead();
    return super.selectedOptions;
  }

  @override
  set selectedOptions(ObservableList<String> value) {
    _$selectedOptionsAtom.reportWrite(value, super.selectedOptions, () {
      super.selectedOptions = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_PostViewModel.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$requestVotingTokenAsyncAction =
      AsyncAction('_PostViewModel.requestVotingToken', context: context);

  @override
  Future<void> requestVotingToken() {
    return _$requestVotingTokenAsyncAction
        .run(() => super.requestVotingToken());
  }

  late final _$voteAsyncAction =
      AsyncAction('_PostViewModel.vote', context: context);

  @override
  Future<void> vote(String optionId) {
    return _$voteAsyncAction.run(() => super.vote(optionId));
  }

  late final _$getResultsAsyncAction =
      AsyncAction('_PostViewModel.getResults', context: context);

  @override
  Future<void> getResults() {
    return _$getResultsAsyncAction.run(() => super.getResults());
  }

  late final _$confirmVotersAsyncAction =
      AsyncAction('_PostViewModel.confirmVoters', context: context);

  @override
  Future<void> confirmVoters() {
    return _$confirmVotersAsyncAction.run(() => super.confirmVoters());
  }

  late final _$_PostViewModelActionController =
      ActionController(name: '_PostViewModel', context: context);

  @override
  void onSelected(String optionId) {
    final _$actionInfo = _$_PostViewModelActionController.startAction(
        name: '_PostViewModel.onSelected');
    try {
      return super.onSelected(optionId);
    } finally {
      _$_PostViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectAll() {
    final _$actionInfo = _$_PostViewModelActionController.startAction(
        name: '_PostViewModel.selectAll');
    try {
      return super.selectAll();
    } finally {
      _$_PostViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalVotes: ${totalVotes},
nftMeta: ${nftMeta},
rows: ${rows},
voteStatus: ${voteStatus},
isLoading: ${isLoading},
isSelectAll: ${isSelectAll},
requestsToVote: ${requestsToVote},
selectedOptions: ${selectedOptions}
    ''';
  }
}
