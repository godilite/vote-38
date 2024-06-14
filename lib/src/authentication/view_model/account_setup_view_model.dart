import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/services/token_service.dart';

part 'account_setup_view_model.g.dart';

sealed class AccountSetupState {}

class AccountSetupInitial extends AccountSetupState {}

class AccountSetupLoading extends AccountSetupState {}

class AccountSetupFailed extends AccountSetupState {}

class AccountSetupSuccess extends AccountSetupState {
  final String accountId;
  final String secretKey;

  AccountSetupSuccess({required this.accountId, required this.secretKey});
}

class AccountSetupViewModel = _AccountSetupViewModel with _$AccountSetupViewModel;

abstract class _AccountSetupViewModel with Store {
  final AssetServiceImpl _assetService;

  _AccountSetupViewModel(this._assetService);

  @observable
  bool isLoading = false;

  @observable
  AccountSetupState accountSetupState = AccountSetupInitial();

  @observable
  String selectedNetwork = 'Testnet';

  @observable
  bool showMenu = false;

  @action
  Future<void> startSetup() async {
    accountSetupState = AccountSetupLoading();
    try {
      final res = await _assetService.createAndFundAccount();
      accountSetupState = AccountSetupSuccess(
        secretKey: res.$1,
        accountId: res.$2,
      );
    } catch (e) {
      debugPrint(e.toString());
      accountSetupState = AccountSetupFailed();
    }
  }
}
