import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class DashboardNavPath implements NavPath {
  const DashboardNavPath();

  @override
  String get name => 'dashboard';

  @override
  String get path => '/dashboard';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
