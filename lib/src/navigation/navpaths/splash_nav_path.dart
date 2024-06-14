import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class SplashNavPath implements NavPath {
  const SplashNavPath();
  @override
  String get path => '/splash';

  @override
  String get name => 'splash';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
