import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class SetupNavPath implements NavPath {
  const SetupNavPath();

  @override
  String get path => '/setup';

  @override
  String get name => 'setup';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
