import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class OnboardingNavPath implements NavPath {
  const OnboardingNavPath();

  @override
  String get name => 'onboarding';

  @override
  String get path => '/onboarding';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
