import 'package:vote38/src/navigation/navpaths/auth_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/createpost_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/dashboard_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/home_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/onboarding_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/result_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/search_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/setting_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/setup_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/sign_up_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/splash_nav_path.dart';

class NavPaths {
  const NavPaths._();

  static const home = HomeNavPath();
  static const splash = SplashNavPath();
  static const signUp = SignUpNavPath();
  static const auth = AuthNavPath();
  static const dashboard = DashboardNavPath();
  static const onboarding = OnboardingNavPath();
  static const setting = SettingNavPath();
  static const search = SearchNavPath();
  static const createpost = CreatepostNavPath();
  static const editpost = EditPostNavPath();
  static const candidate = CandidateNavPath();
  static const nftsetup = NftSetupNavPath();
  static const resultView = ResultViewNavPath();
  static const setup = SetupNavPath();
  static const postDetail = PostDetailNavPath();
  static const voters = VotingListNavPath();
}
