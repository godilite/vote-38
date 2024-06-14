import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  static const pinKey = 'pin';
  static const currentNetwork = 'currentNetwork';
  static const accountSecretKey = 'accountSecret';
  static const accountMnemonicKey = 'accountMnemonic';
  static const accountIDKey = 'accountId';
  static const testAccountSecretKey = 'testaccountSecret';
  static const testMnemonicKey = 'testmnemonic';
  static const testAccountIDKey = 'testaccountid';
  static const isLoggedInKey = 'isLoggedIn';
  static const onboardingCompleteKey = 'onboardingComplete';
  static const testAuthToken = 'testAuthToken';

  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);
}

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageImpl(this._flutterSecureStorage);

  @override
  Future<void> write(String key, String value) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }
}
