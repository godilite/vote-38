import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vote38/src/navigation/navpaths/nav_route.dart';

extension BuildContextX on BuildContext {
  void pushToStack(NavRoute route) => unawaited(push(route.path, extra: route.extra));

  void pushClearStack(NavRoute route) => go(route.path, extra: route.extra);

  void replacePage(NavRoute route) => replace(route.path, extra: route.extra);
}
