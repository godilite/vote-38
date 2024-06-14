// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardViewModel on _DashboardViewModel, Store {
  late final _$postsAtom =
      Atom(name: '_DashboardViewModel.posts', context: context);

  @override
  ObservableList<Post> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableList<Post> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  late final _$accountOwnerSeedAtom =
      Atom(name: '_DashboardViewModel.accountOwnerSeed', context: context);

  @override
  String? get accountOwnerSeed {
    _$accountOwnerSeedAtom.reportRead();
    return super.accountOwnerSeed;
  }

  @override
  set accountOwnerSeed(String? value) {
    _$accountOwnerSeedAtom.reportWrite(value, super.accountOwnerSeed, () {
      super.accountOwnerSeed = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_DashboardViewModel.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$disposeAsyncAction =
      AsyncAction('_DashboardViewModel.dispose', context: context);

  @override
  Future<void> dispose() {
    return _$disposeAsyncAction.run(() => super.dispose());
  }

  @override
  String toString() {
    return '''
posts: ${posts},
accountOwnerSeed: ${accountOwnerSeed}
    ''';
  }
}
