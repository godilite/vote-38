import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class HomeNavPath implements NavPath {
  const HomeNavPath();

  @override
  String get name => 'home';

  @override
  String get path => '/home';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
