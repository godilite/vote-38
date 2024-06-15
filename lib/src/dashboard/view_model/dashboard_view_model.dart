import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/common/models/post.dart';
import 'package:vote38/src/services/model/account.dart';
import 'package:vote38/src/services/post_service.dart';
import 'package:vote38/src/services/secure_storage.dart';

part 'dashboard_view_model.g.dart';

class DashboardViewModel = _DashboardViewModel with _$DashboardViewModel;

abstract class _DashboardViewModel with Store {
  final PostService _postService;
  final SecureStorage _secureStorage;

  _DashboardViewModel(this._postService, this._secureStorage) {
    unawaited(init());
  }

  StreamSubscription<VoteAccount>? _streamSubscription;

  late StreamSubscription<List<Post>> _postSubscription;

  @observable
  ObservableList<Post> posts = ObservableList();

  @observable
  String? accountOwnerSeed;

  @action
  Future<void> init() async {
    accountOwnerSeed = await _secureStorage.read(SecureStorage.testAccountSecretKey);

    if (accountOwnerSeed != null) {
      try {
        final accounts = _postService.postsForAccount(accountOwnerSeed!);

        _postSubscription = accounts.listen((event) {
          posts = ObservableList.of(event);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @action
  Future<void> dispose() async {
    await _postSubscription.cancel();
    await _streamSubscription?.cancel();
  }
}
