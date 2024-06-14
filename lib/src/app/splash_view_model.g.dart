// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SplashViewModel on _SplashViewModelBase, Store {
  late final _$stateAtom =
      Atom(name: '_SplashViewModelBase.state', context: context);

  @override
  SplashState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(SplashState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$nextViewAtom =
      Atom(name: '_SplashViewModelBase.nextView', context: context);

  @override
  NextView get nextView {
    _$nextViewAtom.reportRead();
    return super.nextView;
  }

  @override
  set nextView(NextView value) {
    _$nextViewAtom.reportWrite(value, super.nextView, () {
      super.nextView = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_SplashViewModelBase.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
state: ${state},
nextView: ${nextView}
    ''';
  }
}
