import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class ResultViewNavPath implements NavPath {
  const ResultViewNavPath();

  @override
  String get name => 'results';

  @override
  String get path => '/results';

  @override
  NavRoute route({Object? extra}) {
    return NavRoute(
      path: '/results',
      extra: extra,
    );
  }
}

class PostDetailNavPath implements NavPath {
  const PostDetailNavPath();

  @override
  String get name => 'postDetail';

  @override
  String get path => '/post-detail';

  @override
  NavRoute route({Object? extra}) {
    return NavRoute(
      path: path,
      extra: extra,
    );
  }
}

class VotingListNavPath implements NavPath {
  const VotingListNavPath();

  @override
  String get name => 'voters';

  @override
  String get path => '/voters';

  @override
  NavRoute route({Object? extra}) {
    return NavRoute(
      path: path,
      extra: extra,
    );
  }
}
