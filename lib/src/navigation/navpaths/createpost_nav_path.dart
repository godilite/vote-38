import 'package:vote38/src/navigation/navpaths/base_nav_path.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

class CreatepostNavPath implements NavPath {
  const CreatepostNavPath();

  @override
  String get name => 'createpost';

  @override
  String get path => '/createpost';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}

class EditPostNavPath implements NavPath {
  const EditPostNavPath();

  @override
  String get name => 'editpost';

  @override
  String get path => '/editpost/:id';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: path,
        extra: extra,
      );
}

class CandidateNavPath implements NavPath {
  const CandidateNavPath();

  @override
  String get name => 'candidate';

  @override
  String get path => 'candidate/:id';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: '/createpost/candidate/$extra',
        extra: extra,
      );
}

class NftSetupNavPath implements NavPath {
  const NftSetupNavPath();

  @override
  String get name => 'nftsetup';

  @override
  String get path => 'nftsetup';

  @override
  NavRoute route({Object? extra}) => NavRoute(
        path: '/createpost/nftsetup',
        extra: extra,
      );
}
