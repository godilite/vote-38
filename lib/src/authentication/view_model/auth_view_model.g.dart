// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthViewModel on _AuthViewModel, Store {
  late final _$isLoadingAtom =
      Atom(name: '_AuthViewModel.isLoading', context: context);

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

  late final _$authStateAtom =
      Atom(name: '_AuthViewModel.authState', context: context);

  @override
  AuthState get authState {
    _$authStateAtom.reportRead();
    return super.authState;
  }

  @override
  set authState(AuthState value) {
    _$authStateAtom.reportWrite(value, super.authState, () {
      super.authState = value;
    });
  }

  late final _$performLoginAsyncAction =
      AsyncAction('_AuthViewModel.performLogin', context: context);

  @override
  Future<void> performLogin(String pin) {
    return _$performLoginAsyncAction.run(() => super.performLogin(pin));
  }

  late final _$performSignupAsyncAction =
      AsyncAction('_AuthViewModel.performSignup', context: context);

  @override
  Future<void> performSignup(String pin) {
    return _$performSignupAsyncAction.run(() => super.performSignup(pin));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
authState: ${authState}
    ''';
  }
}
