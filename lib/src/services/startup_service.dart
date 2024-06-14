import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vote38/src/services/secure_storage.dart';

class StartupService {
  final SecureStorage _secureStorage;

  StartupService(this._secureStorage);

  Future<void> init() async {
    final isLoggedIn = await _secureStorage.read(SecureStorage.isLoggedInKey);
    if (isLoggedIn == null || isLoggedIn != 'true') {
      throw NotAuthenticatedException();
    }

    final accountExist = await _secureStorage.read(SecureStorage.testAccountSecretKey);

    if (accountExist == null) {
      throw NoUserException();
    }

    final onboardingComplete = await _secureStorage.read(SecureStorage.onboardingCompleteKey);

    if (onboardingComplete == null) {
      throw OnboardingNotCompleteException();
    }

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      throw NoInternetException();
    }
  }
}

sealed class StartUpException implements Exception {}

class NotAuthenticatedException implements StartUpException {}

class NoUserException implements StartUpException {}

class OnboardingNotCompleteException implements StartUpException {}

class NoInternetException implements StartUpException {}
