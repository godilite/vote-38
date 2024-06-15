// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingViewModel on _SettingViewModel, Store {
  late final _$isLoadingAtom =
      Atom(name: '_SettingViewModel.isLoading', context: context);

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

  late final _$isDarkModeAtom =
      Atom(name: '_SettingViewModel.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$settingsAtom =
      Atom(name: '_SettingViewModel.settings', context: context);

  @override
  Setting get settings {
    _$settingsAtom.reportRead();
    return super.settings;
  }

  @override
  set settings(Setting value) {
    _$settingsAtom.reportWrite(value, super.settings, () {
      super.settings = value;
    });
  }

  late final _$accountAtom =
      Atom(name: '_SettingViewModel.account', context: context);

  @override
  VoteAccount? get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(VoteAccount? value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  late final _$getSettingsAsyncAction =
      AsyncAction('_SettingViewModel.getSettings', context: context);

  @override
  Future<void> getSettings() {
    return _$getSettingsAsyncAction.run(() => super.getSettings());
  }

  late final _$loadAccountAsyncAction =
      AsyncAction('_SettingViewModel.loadAccount', context: context);

  @override
  Future<void> loadAccount() {
    return _$loadAccountAsyncAction.run(() => super.loadAccount());
  }

  late final _$updateSettingAsyncAction =
      AsyncAction('_SettingViewModel.updateSetting', context: context);

  @override
  Future<void> updateSetting() {
    return _$updateSettingAsyncAction.run(() => super.updateSetting());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isDarkMode: ${isDarkMode},
settings: ${settings},
account: ${account}
    ''';
  }
}
