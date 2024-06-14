import 'package:mobx/mobx.dart';
import 'package:vote38/src/services/secure_storage.dart';

part 'onboarding_view_model.g.dart';

class OnboardingViewModel = _OnboardingViewModel with _$OnboardingViewModel;

abstract class _OnboardingViewModel with Store {
  final SecureStorage _secureStorage;

  _OnboardingViewModel(this._secureStorage);

  @observable
  bool isComplete = false;

  @action
  Future<void> completeOnboarding() async {
    isComplete = true;
    await _secureStorage.write(SecureStorage.onboardingCompleteKey, 'true');
  }
}
