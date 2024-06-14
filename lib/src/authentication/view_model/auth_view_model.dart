import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/app/vote_chain_app.dart';
import 'package:vote38/src/authentication/view_model/auth_state.dart';
import 'package:vote38/src/services/auth_service.dart';

part 'auth_view_model.g.dart';

class AuthViewModel = _AuthViewModel with _$AuthViewModel;

abstract class _AuthViewModel with Store {
  final AuthService _authService;

  _AuthViewModel(this._authService);

  @observable
  bool isLoading = false;

  @observable
  AuthState authState = AuthLoading();

  final ValueNotifier<bool> authListenable = ValueNotifier<bool>(false);

  Future<void> checkLoginStatus() async {
    final result = await _authService.checkLoginStatus();
    authState = result;
  }

  @action
  Future<void> performLogin(String pin) async {
    isLoading = true;
    final result = await _authService.performLogin(pin);
    isLoading = false;
    authState = result;
    appRouter?.refresh();
  }

  @action
  Future<void> performSignup(String pin) async {
    isLoading = true;
    final result = await _authService.signUp(pin);
    isLoading = false;
    authState = result;
    appRouter?.refresh();
  }
}
