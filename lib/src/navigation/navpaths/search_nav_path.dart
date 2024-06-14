import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class SearchNavPath implements NavPath {
  const SearchNavPath();

  @override
  String get name => 'search';

  @override
  String get path => '/search';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}
