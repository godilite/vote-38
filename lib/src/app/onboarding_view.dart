import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/app/onboarding_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

class OnboardingView extends StatelessWidget {
  final OnboardingViewModel viewModel;
  const OnboardingView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
      builder: (context) {
        return reaction(
          (_) => viewModel.isComplete,
          (isComplete) {
            if (isComplete) {
              context.pushClearStack(NavPaths.splash.route());
            }
          },
        );
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Welcome to Vote38',
                  textAlign: TextAlign.center,
                  style: context.moonTypography?.heading.text32.copyWith(
                    color: context.moonColors?.roshi,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(height: 300, child: LottieBuilder.asset('assets/images/secure.json')),
                Text(
                  'Vote38 is secure and transparent, ensuring your vote is counted. Create you posts and vote on others.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.moonColors?.bulma,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 100),
                MoonButton(
                  backgroundColor: context.moonColors?.krillin,
                  onTap: () async {
                    await viewModel.completeOnboarding();
                  },
                  label: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
