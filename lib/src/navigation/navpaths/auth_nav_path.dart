import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class AuthNavPath implements NavPath {
  const AuthNavPath();

  @override
  String get name => 'auth';

  @override
  String get path => '/auth';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
