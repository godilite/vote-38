import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/common/mapper/post_view_mapper.dart';
import 'package:vote38/src/common/models/post.dart';
import 'package:vote38/src/services/model/account.dart';
import 'package:vote38/src/services/post_service.dart';
import 'package:vote38/src/services/secure_storage.dart';
import 'package:vote38/src/services/token_service.dart';

part 'dashboard_view_model.g.dart';

class DashboardViewModel = _DashboardViewModel with _$DashboardViewModel;

abstract class _DashboardViewModel with Store {
  final AssetServiceImpl _serviceInterface;
  final PostService _postService;
  final SecureStorage _secureStorage;

  _DashboardViewModel(this._serviceInterface, this._postService, this._secureStorage) {
    unawaited(init());
  }

  StreamSubscription<VoteAccount>? _streamSubscription;

  @observable
  ObservableList<Post> posts = ObservableList();

  @observable
  String? accountOwnerSeed;

  @action
  Future<void> init() async {
    accountOwnerSeed = await _secureStorage.read(SecureStorage.testAccountSecretKey);

    if (accountOwnerSeed != null) {
      try {
        final accounts = await _postService.postsForAccount(accountOwnerSeed!);

        final data = mapAccountToPost(accounts);
        posts = ObservableList.of(data);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    await _subscripeToUserPosts();
  }

  Future<void> _subscripeToUserPosts() async {
    await _streamSubscription?.cancel();
  }

  @action
  Future<void> dispose() async {
    await _streamSubscription?.cancel();
  }
}
