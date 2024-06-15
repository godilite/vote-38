import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:vote38/src/services/mapper/account_mapper.dart';
import 'package:vote38/src/services/model/account.dart';
import 'package:vote38/src/services/secure_storage.dart';
import 'package:vote38/src/settings/model/setting.dart';

part 'setting_view_model.g.dart';

class SettingViewModel = _SettingViewModel with _$SettingViewModel;

abstract class _SettingViewModel with Store {
  final Box<Setting> _settingStore;
  final StellarSDK _sdk;
  final SecureStorage _secureStorage;
  final AccountResponseMapper _accountResponseMapper;

  _SettingViewModel(this._settingStore, this._sdk, this._secureStorage, this._accountResponseMapper) : account = null {
    unawaited(getSettings());
  }

  @observable
  bool isLoading = false;

  @observable
  bool isDarkMode = true;

  @observable
  Setting settings = Setting(isDarkMode: true);

  @observable
  VoteAccount? account;

  @action
  Future<void> getSettings() async {
    isLoading = true;
    settings = _settingStore.get('settings', defaultValue: Setting(isDarkMode: true))!;
    isLoading = false;

    reaction((p0) => isDarkMode, (isDarkMode) {
      updateSetting();
    });
  }

  @action
  Future<void> loadAccount() async {
    final accountSecret = await _secureStorage.read(SecureStorage.testAccountSecretKey);

    if (accountSecret != null) {
      account = await _sdk.accounts.account(KeyPair.fromSecretSeed(accountSecret).accountId).then((value) {
        return _accountResponseMapper.mapAccountResponse(value, accountSecret);
      });
    }
  }

  @action
  Future<void> updateSetting() async {
    final newSettings = settings.copyWith(
      isDarkMode: isDarkMode,
    );

    await _settingStore.put('settings', newSettings);
  }
}
