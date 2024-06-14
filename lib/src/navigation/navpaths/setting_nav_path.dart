import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class SettingNavPath implements NavPath {
  const SettingNavPath();

  @override
  String get name => 'setting';

  @override
  String get path => '/setting';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
