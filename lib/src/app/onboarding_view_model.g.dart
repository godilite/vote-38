// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingViewModel on _OnboardingViewModel, Store {
  late final _$isCompleteAtom =
      Atom(name: '_OnboardingViewModel.isComplete', context: context);

  @override
  bool get isComplete {
    _$isCompleteAtom.reportRead();
    return super.isComplete;
  }

  @override
  set isComplete(bool value) {
    _$isCompleteAtom.reportWrite(value, super.isComplete, () {
      super.isComplete = value;
    });
  }

  late final _$completeOnboardingAsyncAction =
      AsyncAction('_OnboardingViewModel.completeOnboarding', context: context);

  @override
  Future<void> completeOnboarding() {
    return _$completeOnboardingAsyncAction
        .run(() => super.completeOnboarding());
  }

  @override
  String toString() {
    return '''
isComplete: ${isComplete}
    ''';
  }
}
