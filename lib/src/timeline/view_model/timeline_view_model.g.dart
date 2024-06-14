// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimelineViewModel on _TimelineViewModel, Store {
  late final _$isLoadingAtom =
      Atom(name: '_TimelineViewModel.isLoading', context: context);

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

  late final _$postsAtom =
      Atom(name: '_TimelineViewModel.posts', context: context);

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

  late final _$disposeAsyncAction =
      AsyncAction('_TimelineViewModel.dispose', context: context);

  @override
  Future<void> dispose() {
    return _$disposeAsyncAction.run(() => super.dispose());
  }

  late final _$_TimelineViewModelActionController =
      ActionController(name: '_TimelineViewModel', context: context);

  @override
  void postStream() {
    final _$actionInfo = _$_TimelineViewModelActionController.startAction(
        name: '_TimelineViewModel.postStream');
    try {
      return super.postStream();
    } finally {
      _$_TimelineViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
posts: ${posts}
    ''';
  }
}
