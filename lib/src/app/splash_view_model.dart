import 'package:mobx/mobx.dart';
import 'package:vote38/src/services/startup_service.dart';

part 'splash_view_model.g.dart';

enum SplashState { loading, loaded }

enum NextView { init, home, login, onboarding, setup }

class SplashViewModel = _SplashViewModelBase with _$SplashViewModel;

abstract class _SplashViewModelBase with Store {
  final StartupService _startupService;

  @observable
  SplashState state = SplashState.loading;

  @observable
  NextView nextView = NextView.init;

  _SplashViewModelBase(this._startupService);

  @action
  Future<void> init() async {
    try {
      await _startupService.init();
      nextView = NextView.home;
    } catch (e) {
      final startupException = e as StartUpException;

      switch (startupException) {
        case NotAuthenticatedException():
          nextView = NextView.login;
        case NoUserException():
          nextView = NextView.setup;
        case OnboardingNotCompleteException():
          nextView = NextView.onboarding;

        case NoInternetException():
          nextView = NextView.login;
      }
    }

    state = SplashState.loaded;
  }
}
