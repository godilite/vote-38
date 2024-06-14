// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/app/home_view_model.dart';

class HomeView extends StatelessWidget {
  final Widget child;
  final HomeViewModel viewModel;
  const HomeView({super.key, required this.child, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          body: child,
          extendBody: true,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: context.moonColors?.beerus,
              ),
              child: BottomNavigationBar(
                currentIndex: viewModel.currentIndex,
                elevation: 0,
                backgroundColor: context.moonColors?.beerus,
                selectedItemColor: context.moonColors?.roshi,
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: context.moonColors?.bulma,
                  fontFamily: 'RedHatText',
                ),
                selectedLabelStyle: TextStyle(
                  color: context.moonColors?.krillin,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'RedHatText',
                ),
                onTap: (v) => viewModel.navigate(context, v),
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/activity.svg',
                      color: viewModel.currentIndex == 0 ? context.moonColors?.krillin : context.moonColors?.bulma,
                    ),
                    label: 'Timeline',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/chart.svg',
                      color: viewModel.currentIndex == 1 ? context.moonColors?.krillin : context.moonColors?.bulma,
                    ),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/setting.svg',
                      color: viewModel.currentIndex == 2 ? context.moonColors?.krillin : context.moonColors?.bulma,
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
