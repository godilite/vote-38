// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_setup_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AccountSetupViewModel on _AccountSetupViewModel, Store {
  late final _$isLoadingAtom =
      Atom(name: '_AccountSetupViewModel.isLoading', context: context);

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

  late final _$accountSetupStateAtom =
      Atom(name: '_AccountSetupViewModel.accountSetupState', context: context);

  @override
  AccountSetupState get accountSetupState {
    _$accountSetupStateAtom.reportRead();
    return super.accountSetupState;
  }

  @override
  set accountSetupState(AccountSetupState value) {
    _$accountSetupStateAtom.reportWrite(value, super.accountSetupState, () {
      super.accountSetupState = value;
    });
  }

  late final _$selectedNetworkAtom =
      Atom(name: '_AccountSetupViewModel.selectedNetwork', context: context);

  @override
  String get selectedNetwork {
    _$selectedNetworkAtom.reportRead();
    return super.selectedNetwork;
  }

  @override
  set selectedNetwork(String value) {
    _$selectedNetworkAtom.reportWrite(value, super.selectedNetwork, () {
      super.selectedNetwork = value;
    });
  }

  late final _$showMenuAtom =
      Atom(name: '_AccountSetupViewModel.showMenu', context: context);

  @override
  bool get showMenu {
    _$showMenuAtom.reportRead();
    return super.showMenu;
  }

  @override
  set showMenu(bool value) {
    _$showMenuAtom.reportWrite(value, super.showMenu, () {
      super.showMenu = value;
    });
  }

  late final _$startSetupAsyncAction =
      AsyncAction('_AccountSetupViewModel.startSetup', context: context);

  @override
  Future<void> startSetup() {
    return _$startSetupAsyncAction.run(() => super.startSetup());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
accountSetupState: ${accountSetupState},
selectedNetwork: ${selectedNetwork},
showMenu: ${showMenu}
    ''';
  }
}
