import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/common/mapper/post_view_mapper.dart';
import 'package:vote38/src/common/models/post.dart';
import 'package:vote38/src/common/models/voting_request_data.dart';
import 'package:vote38/src/services/post_service.dart';
import 'package:vote38/src/services/secure_storage.dart';
import 'package:vote38/src/services/token_service.dart';
import 'package:vote38/src/services/voting_service.dart';

part 'post_view_model.g.dart';

enum VoteStatus {
  initial,
  restricted,
  canVote,
  alreadyVoted,
  requestedToken,
  owner,
}

enum CastVoteStatus {
  initial,
  loading,
  success,
  error,
}

class PostViewModel = _PostViewModel with _$PostViewModel;

abstract class _PostViewModel with Store {
  final String postId;
  final String nftCid;
  final PostService _postService;
  final VotingService _votingService;
  final SecureStorage _secureStorage;
  final AssetServiceImpl _assetService;
  final Post post;

  _PostViewModel(
    this.postId,
    this.nftCid,
    this._postService,
    this._votingService,
    this.post,
    this._secureStorage,
    this._assetService,
  );

  @observable
  double totalVotes = 0;

  @observable
  NftMeta? nftMeta;

  @observable
  List<OptionData> rows = [];

  List<String> columns = ['Name', 'Votes'];

  @observable
  VoteStatus voteStatus = VoteStatus.initial;

  @observable
  bool isLoading = false;

  @observable
  bool isSelectAll = false;

  @observable
  CastVoteStatus castVoteStatus = CastVoteStatus.initial;

  @observable
  ObservableList<VotingRequestData> requestsToVote = ObservableList();

  @observable
  ObservableList<String> selectedOptions = ObservableList();

  @action
  Future<void> init() async {
    nftMeta = await _postService.getNftMeta(nftCid);
    try {
      await _postService.getVotingOptionsByPost(postId).then((value) {
        final balances = value.expand((element) => element.balances);

        final nftBalance =
            balances.where((element) => element.assetCode == nftMeta?.code && element.assetIssuer == nftMeta?.issuer);

        totalVotes = nftBalance.fold(0.0, (previousValue, element) => previousValue + double.parse(element.balance));
      });

      final accountId = await _secureStorage.read(SecureStorage.testAccountIDKey);
      if (accountId == nftMeta?.issuer) {
        voteStatus = VoteStatus.owner;
        if (voteStatus == VoteStatus.owner) {
          _subscribeToVotingRequests();
        }
        return;
      }
      await updateVotingStatus();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateVotingStatus() async {
    final isCanVote = await _votingService.canVote(nftMeta!.code, nftMeta!.issuer);
    final hasRequestedVotingToken = _votingService.hasRequestedVotingToken(postId);

    if (isCanVote) {
      voteStatus = VoteStatus.canVote;
    } else {
      final hasVoted = await _votingService.hasVoted(nftMeta!.code);
      if (hasVoted) {
        voteStatus = VoteStatus.alreadyVoted;
      } else if (hasRequestedVotingToken) {
        voteStatus = VoteStatus.requestedToken;
      } else {
        voteStatus = VoteStatus.restricted;
      }
    }
  }

  void _subscribeToVotingRequests() {
    _votingService.subscribeRequests(postId).listen((event) {
      if (event != null) {
        debugPrint(event.toString());
        requestsToVote.add(event);
      }
    });
  }

  @action
  Future<void> requestVotingToken() async {
    isLoading = true;
    try {
      await _votingService.requestVotingToken(postId, nftMeta!.issuer, nftMeta!.code);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
  }

  @action
  Future<void> vote(String optionId) async {
    castVoteStatus = CastVoteStatus.loading;
    try {
      await _votingService.vote(optionId, nftMeta!.code, nftMeta!.issuer);
      castVoteStatus = CastVoteStatus.success;
    } catch (e) {
      castVoteStatus = CastVoteStatus.error;
      debugPrint(e.toString());
    }
  }

  @action
  Future<void> getResults() async {
    await updateVotingStatus();
    await _postService.getVotingOptionsByPost(postId).then((value) {
      rows = mapOptionsAccountToPost(value, post, nftMeta!.code);
    });
  }

  @action
  void onSelected(String optionId) {
    isSelectAll = false;
    if (selectedOptions.contains(optionId)) {
      selectedOptions.remove(optionId);
    } else {
      selectedOptions.add(optionId);
    }
  }

  @action
  void selectAll() {
    isSelectAll = !isSelectAll;
    if (isSelectAll) {
      selectedOptions = ObservableList.of(requestsToVote.map((e) => e.voterId));
    } else {
      selectedOptions.clear();
    }
  }

  @action
  Future<void> confirmVoters() async {
    isLoading = true;
    if (selectedOptions.isEmpty) {
      isLoading = false;
      return;
    }
    final accountSeed = await _secureStorage.read(SecureStorage.testAccountSecretKey);
    if (accountSeed == null) {
      isLoading = false;
      return;
    }

    if (isSelectAll) {
      selectedOptions.clear();
      requestsToVote.clear();
      await _assetService.transfer(
        nftMeta!.code,
        accountSeed,
        nftMeta!.issuer,
      );
      await _votingService.deleteAllRequests(postId);
    }
    {
      for (final voterId in selectedOptions) {
        selectedOptions.remove(voterId);
        requestsToVote.removeWhere((element) => element.voterId == voterId);

        await compute(
          (List<String> v) {
            for (final voterId in v) {
              _assetService.transfer(
                nftMeta!.code,
                accountSeed,
                voterId,
              );
            }
          },
          selectedOptions,
        );

        await _votingService.deleteRequest(voterId, postId);
      }
    }
    isLoading = false;
  }

  bool isSelected(String optionId) => selectedOptions.contains(optionId);
}
