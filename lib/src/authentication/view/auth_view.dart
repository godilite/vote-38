import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/authentication/view_model/auth_state.dart';
import 'package:vote38/src/authentication/view_model/auth_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

class AuthView extends StatefulWidget {
  final bool isSetup;
  final AuthViewModel viewModel;
  const AuthView({super.key, this.isSetup = false, required this.viewModel});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _controller = TextEditingController();

  bool _isConfirm = false;

  String _pin = '';

  void _onPinChange(String value) {
    if (widget.isSetup) {
      if (_isConfirm) {
        if (_pin == value) {
          unawaited(widget.viewModel.performSignup(value));
        } else {
          MoonToast.show(
            context,
            label: const Text('Pin code does not match'),
          );
        }
      } else {
        _pin = value;
        setState(() {
          _isConfirm = true;
        });
      }
    } else {
      unawaited(widget.viewModel.performLogin(value));
    }
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
      builder: (_) {
        return reaction(
          (_) => widget.viewModel.authState,
          (state) {
            switch (state) {
              case LoginFailed():
                MoonToast.show(
                  context,
                  isPersistent: false,
                  label: const Text('Invalid pin code'),
                );
              case LoginSuccess():
                MoonToast.show(
                  context,
                  leading: const Icon(MoonIcons.generic_check_alternative_32_regular),
                  label: const Text('Authenticated'),
                );
              case AccountSetupRequired():
                context.pushClearStack(NavPaths.setup.route());
              case SignupSuccess():
                context.pushClearStack(NavPaths.setup.route());
              case OnboardingNotComplete():
                context.pushClearStack(NavPaths.onboarding.route());
              default:
            }
          },
        );
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              if (widget.isSetup)
                Text(
                  _isConfirm ? 'Confirm your pin code' : 'Setup pin code',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              const SizedBox(height: 16),
              Text(
                'Enter your pin code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.moonColors?.roshi,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              MoonAuthCode(
                authInputFieldCount: 4,
                gap: 30,
                textController: _controller,
                activeFillColor: context.moonColors?.roshi,
                activeBorderColor: context.moonColors?.roshi,
                selectedBorderColor: context.moonColors?.roshi,
                onCompleted: _onPinChange,
                validator: (value) => null,
                errorBuilder: (context, error) {
                  return Text(
                    error ?? '',
                    style: TextStyle(color: context.moonColors!.chichi60),
                  );
                },
              ),
              const Spacer(),
              if (widget.isSetup)
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: context.moonColors?.trunks),
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(color: context.moonColors?.roshi, fontWeight: FontWeight.w700),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushToStack(NavPaths.auth.route());
                          },
                      ),
                    ],
                  ),
                )
              else
                RichText(
                  text: TextSpan(
                    text: "Don't have a pin? ",
                    style: TextStyle(color: context.moonColors?.trunks),
                    children: [
                      TextSpan(
                        text: 'Set up',
                        style: TextStyle(color: context.moonColors?.roshi, fontWeight: FontWeight.w700),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushToStack(NavPaths.signUp.route());
                          },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
