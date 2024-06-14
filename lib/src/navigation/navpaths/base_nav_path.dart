import 'package:vote38/src/navigation/navpaths/nav_route.dart';

abstract class NavPath {
  String get name;
  String get path;
  NavRoute route({Object? extra});
}
