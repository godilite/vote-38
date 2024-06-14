import 'package:vote38/src/authentication/view_model/auth_state.dart';
import 'package:vote38/src/services/secure_storage.dart';

class AuthService {
  final SecureStorage _secureStorage;

  AuthService(this._secureStorage);

  Future<AuthState> checkLoginStatus() async {
    final isLoggedIn = await _secureStorage.read(SecureStorage.isLoggedInKey);

    if (isLoggedIn == 'true') {
      final accountSecret = await _secureStorage.read(SecureStorage.testAccountSecretKey);

      if (accountSecret == null) {
        return AccountSetupRequired();
      }

      return LoginSuccess();
    }

    return LoginFailed();
  }

  Future<AuthState> performLogin(String pin) async {
    final currentPin = await _secureStorage.read(SecureStorage.pinKey);
    final onboarding = await _secureStorage.read(SecureStorage.onboardingCompleteKey);

    if (currentPin == pin) {
      final accountSecret = await _secureStorage.read(SecureStorage.testAccountSecretKey);
      await _secureStorage.write(SecureStorage.isLoggedInKey, 'true');

      if (accountSecret == null) {
        return AccountSetupRequired();
      }

      if (onboarding == null) {
        return OnboardingNotComplete();
      }

      return LoginSuccess();
    }

    return LoginFailed();
  }

  Future<void> performLogout() async {
    await _secureStorage.delete(SecureStorage.isLoggedInKey);
  }

  Future<AuthState> signUp(String pin) async {
    await _secureStorage.write(SecureStorage.pinKey, pin);
    await _secureStorage.write(SecureStorage.isLoggedInKey, 'true');
    return SignupSuccess();
  }
}
