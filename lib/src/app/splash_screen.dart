import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/app/splash_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

class SplashScreen extends StatefulWidget {
  final SplashViewModel viewModel;

  const SplashScreen(this.viewModel);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    unawaited(widget.viewModel.init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
      builder: (context) {
        return reaction(
          (_) => widget.viewModel.nextView,
          (state) {
            switch (state) {
              case NextView.login:
                context.pushClearStack(NavPaths.auth.route());
              case NextView.setup:
                context.pushClearStack(NavPaths.setup.route());
              case NextView.home:
                context.pushClearStack(NavPaths.home.route());
              case NextView.onboarding:
                context.pushClearStack(NavPaths.onboarding.route());
              case NextView.init:
              // TODO: Handle this case.
            }
          },
        );
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            Center(
              child: Text(
                'Vote38',
                textAlign: TextAlign.center,
                style: context.moonTypography?.heading.text56.copyWith(
                  color: context.moonColors?.roshi,
                  fontFamily: 'RubikGlitchPop',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.viewModel.state == SplashState.loading)
              MoonCircularLoader(
                circularLoaderSize: MoonCircularLoaderSize.xs,
                color: context.moonColors?.krillin60,
              ),
          ],
        ),
      ),
    );
  }
}
