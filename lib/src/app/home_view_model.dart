import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

part 'home_view_model.g.dart';

class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store {
  _HomeViewModelBase();

  @observable
  int currentIndex = 0;

  void navigate(
    BuildContext context,
    int index,
  ) {
    currentIndex = index;
    switch (index) {
      case 0:
        context.pushClearStack(NavPaths.home.route());
      case 1:
        context.pushClearStack(NavPaths.dashboard.route());
      case 2:
        context.pushClearStack(NavPaths.setting.route());
    }
  }
}
