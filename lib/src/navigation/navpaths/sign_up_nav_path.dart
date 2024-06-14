import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class SignUpNavPath implements NavPath {
  const SignUpNavPath();

  @override
  String get name => 'signUp';

  @override
  String get path => '/signUp';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
