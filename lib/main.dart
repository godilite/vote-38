import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vote38/firebase_options.dart';
import 'package:vote38/src/app/vote_chain_app.dart';
import 'package:vote38/src/di/di.dart';
import 'package:vote38/src/services/model/account.dart';
import 'package:vote38/src/services/secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     debugPrint(e);
  //   }
  // }
  await _setupHive();

  setupDI();
  runApp(const VoteChainApp());
}

Future<void> _setupHive() async {
  await Hive.initFlutter();

  const keyStoreKey = 'votesack_key';
  Hive.registerAdapter(VoteAccountAdapter());
  Hive.registerAdapter(VoteBalanceAdapter());
  Hive.registerAdapter(VoteSignerAdapter());
  Hive.registerAdapter(AccountThresholdsAdapter());
  Hive.registerAdapter(HorizonFlagsAdapter());
  Hive.registerAdapter(LinkItemAdapter());
  Hive.registerAdapter(AccountLinksAdapter());
  Hive.registerAdapter(AccountDataAdapter());

  getIt.registerFactory<SecureStorage>(
    () => SecureStorageImpl(const FlutterSecureStorage()),
  );

  final secureStorage = getIt.get<SecureStorage>();
  final encryptionKeyString = await secureStorage.read(keyStoreKey);
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      keyStoreKey,
      base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(keyStoreKey);
  final encryptionKeyUint8List = base64Url.decode(key!);
  await Hive.openBox<VoteAccount>(
    VoteAccount.boxName,
    encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
  );
  await Hive.openBox<VoteBalance>(
    VoteBalance.boxName,
    encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
  );
  await Hive.openBox<int>(
    'progress',
    encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
  );
  await Hive.openBox<bool>(
    'votingrequests',
    encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
  );
}
