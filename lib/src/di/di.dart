import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:vote38/src/app/home_view_model.dart';
import 'package:vote38/src/app/onboarding_view_model.dart';
import 'package:vote38/src/app/splash_view_model.dart';
import 'package:vote38/src/authentication/view_model/account_setup_view_model.dart';
import 'package:vote38/src/authentication/view_model/auth_view_model.dart';
import 'package:vote38/src/dashboard/view_model/create_post_view_model.dart';
import 'package:vote38/src/dashboard/view_model/dashboard_view_model.dart';
import 'package:vote38/src/services/auth_service.dart';
import 'package:vote38/src/services/mapper/account_mapper.dart';
import 'package:vote38/src/services/model/account.dart';
import 'package:vote38/src/services/post_service.dart';
import 'package:vote38/src/services/secure_storage.dart';
import 'package:vote38/src/services/startup_service.dart';
import 'package:vote38/src/services/token_service.dart';
import 'package:vote38/src/services/voting_service.dart';
import 'package:vote38/src/settings/model/setting.dart';
import 'package:vote38/src/settings/viewmodel/setting_view_model.dart';
import 'package:vote38/src/timeline/view_model/timeline_view_model.dart';

GetIt getIt = GetIt.instance;

void setupDI() {
  getIt.registerSingleton<StartupService>(StartupService(getIt<SecureStorage>()));

  getIt.registerSingleton<SplashViewModel>(SplashViewModel(getIt()));

  getIt.registerFactory<AuthService>(() => AuthService(getIt()));

  getIt.registerSingleton<AuthViewModel>(AuthViewModel(getIt()));

  getIt.registerSingleton<HomeViewModel>(HomeViewModel());

  getIt.registerSingleton<AssetServiceImpl>(
    AssetServiceImpl(
      getIt(),
      Hive.box('progress'),
      Network.TESTNET,
      StellarSDK.TESTNET,
    ),
  );

  getIt.registerFactory(() => AccountResponseMapper());

  getIt.registerFactory(() => OnboardingViewModel(getIt()));

  getIt.registerFactory(() => AccountSetupViewModel(getIt()));

  getIt.registerSingleton<PostService>(
    PostServiceImpl(
      StellarSDK.TESTNET,
      Network.TESTNET,
      getIt(),
      Hive.box(VoteAccount.boxName),
      FirebaseFirestore.instance,
    ),
  );
  getIt.registerLazySingleton<DashboardViewModel>(() => DashboardViewModel(getIt(), getIt()));
  getIt.registerSingleton<CreatePostViewModel>(CreatePostViewModel(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<TimelineViewModel>(() => TimelineViewModel(FirebaseFirestore.instance));
  getIt.registerFactory(
    () => VotingService(
      StellarSDK.TESTNET,
      FirebaseFirestore.instance,
      getIt(),
      Network.TESTNET,
      Hive.box('votingrequests'),
    ),
  );

  getIt.registerSingleton<SettingViewModel>(
    SettingViewModel(
      Hive.box(Setting.boxName),
      StellarSDK.TESTNET,
      getIt(),
      getIt(),
    ),
  );
}
