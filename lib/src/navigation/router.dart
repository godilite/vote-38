import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vote38/src/app/home_view.dart';
import 'package:vote38/src/app/home_view_model.dart';
import 'package:vote38/src/app/onboarding_view.dart';
import 'package:vote38/src/app/onboarding_view_model.dart';
import 'package:vote38/src/app/splash_screen.dart';
import 'package:vote38/src/app/splash_view_model.dart';
import 'package:vote38/src/authentication/view/account_setup_view.dart';
import 'package:vote38/src/authentication/view/auth_view.dart';
import 'package:vote38/src/authentication/view_model/account_setup_view_model.dart';
import 'package:vote38/src/authentication/view_model/auth_state.dart';
import 'package:vote38/src/authentication/view_model/auth_view_model.dart';
import 'package:vote38/src/common/post_view/post_detail_page.dart';
import 'package:vote38/src/common/post_view/result_view.dart';
import 'package:vote38/src/common/post_view/view_model/post_view_model.dart';
import 'package:vote38/src/common/post_view/voting_request_list_view.dart';
import 'package:vote38/src/dashboard/view/create_post_view.dart';
import 'package:vote38/src/dashboard/view/dashboard_view.dart';
import 'package:vote38/src/dashboard/view/edit_candidate_view.dart';
import 'package:vote38/src/dashboard/view/nft_view.dart';
import 'package:vote38/src/dashboard/view_model/create_post_view_model.dart';
import 'package:vote38/src/dashboard/view_model/dashboard_view_model.dart';
import 'package:vote38/src/di/di.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/settings/view/setting_view.dart';
import 'package:vote38/src/timeline/view/search_view.dart';
import 'package:vote38/src/timeline/view/timeline_view.dart';
import 'package:vote38/src/timeline/view_model/timeline_view_model.dart';

class AppRouter {
  static final ignoreAuthRoutes = [
    '/signin',
    '/',
    NavPaths.auth.path,
    NavPaths.dashboard.path,
    NavPaths.splash.path,
    NavPaths.home.path,
    NavPaths.setting.path,
    NavPaths.search.path,
    NavPaths.createpost.path,
    NavPaths.editpost.path,
    NavPaths.candidate.path,
    '/authenticator',
    '/link-wallet',
    '/welcome',
    '/seed',
  ];
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: _gaurdRedirect,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/splash'),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => NoTransitionPage(child: SplashScreen(getIt<SplashViewModel>())),
      ),
      GoRoute(
        path: NavPaths.auth.path,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AuthView(
            viewModel: getIt<AuthViewModel>(),
          ),
        ),
      ),
      GoRoute(
        path: NavPaths.signUp.path,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AuthView(
            viewModel: getIt<AuthViewModel>(),
            isSetup: true,
          ),
        ),
      ),
      GoRoute(
        path: NavPaths.setup.path,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AccountSetupView(
            viewModel: getIt<AccountSetupViewModel>(),
          ),
        ),
      ),
      GoRoute(
        path: NavPaths.onboarding.path,
        pageBuilder: (context, state) => NoTransitionPage(
          child: OnboardingView(
            viewModel: getIt<OnboardingViewModel>(),
          ),
        ),
      ),
      GoRoute(
        path: NavPaths.resultView.path,
        pageBuilder: (context, state) {
          final extraData = state.extra! as PostViewModel;

          return NoTransitionPage(
            child: ResultView(
              viewModel: extraData..getResults(),
            ),
          );
        },
      ),
      GoRoute(
        path: NavPaths.voters.path,
        pageBuilder: (context, state) {
          final extraData = state.extra! as PostViewModel;

          return NoTransitionPage(
            child: VotingRequestListView(
              viewModel: extraData,
            ),
          );
        },
      ),
      GoRoute(
        path: NavPaths.postDetail.path,
        pageBuilder: (context, state) {
          final extraData = state.extra! as PostViewModel;

          return NoTransitionPage(
            child: PostDetailPage(
              viewModel: extraData,
            ),
          );
        },
      ),
      GoRoute(
        path: NavPaths.createpost.path,
        pageBuilder: (context, state) => SlideUpTransition(
          child: CreatePostView(
            viewModel: getIt<CreatePostViewModel>()..init(),
          ),
        ),
        routes: [
          GoRoute(
            path: NavPaths.candidate.path,
            pageBuilder: (context, state) => SlideUpTransition(
              child: EditCandidateView(id: state.extra! as String, viewModel: getIt<CreatePostViewModel>()),
            ),
          ),
          GoRoute(
            path: NavPaths.nftsetup.path,
            pageBuilder: (context, state) => NoTransitionPage(
              child: NftView(
                viewModel: getIt<CreatePostViewModel>(),
              ),
            ),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => HomeView(
          viewModel: getIt<HomeViewModel>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: NavPaths.home.path,
            pageBuilder: (context, state) => NoTransitionPage(
              child: TimelineView(
                viewModel: getIt.get<TimelineViewModel>(),
              ),
            ),
          ),
          GoRoute(
            path: NavPaths.dashboard.path,
            pageBuilder: (context, state) => NoTransitionPage(
              child: DashboardView(
                viewModel: getIt<DashboardViewModel>()..init(),
              ),
            ),
          ),
          GoRoute(
            path: NavPaths.setting.path,
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingView()),
          ),
          GoRoute(
            path: NavPaths.search.path,
            pageBuilder: (context, state) => const NoTransitionPage(child: SearchView()),
          ),
        ],
      ),
    ],
  );

  GoRouter get router => _router;
}

String? _gaurdRedirect(BuildContext context, GoRouterState state) {
  // await getIt.get<AuthViewModel>().checkLoginStatus();
  final authState = getIt.get<AuthViewModel>().authState;

  switch (state.matchedLocation) {
    case '/auth':
      return switch (authState) {
        LoginSuccess() => '/timeline',
        LoginFailed() => '/auth',
        AccountSetupRequired() => '/setup',
        OnboardingNotComplete() => '/onboarding',
        _ => null,
      };
    case '/splash':
      return null;
    case '/signUp':
      return null;
    case '/setup':
      return null;
    default:
      if (authState is LoginFailed) {
        return '/auth';
      }

      return null;
  }

  // final isIgnored = AppRouter.ignoreAuthRoutes.contains(state.matchedLocation);

  // if (!isAuthed && !isIgnored) {
  //   return NavPaths.auth.path;
  // }
}

class SlideUpTransition<T> extends CustomTransitionPage<T> {
  SlideUpTransition({
    required super.child,
    super.barrierDismissible = true,
    super.barrierColor,
    super.barrierLabel,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.maintainState,
    super.fullscreenDialog,
    super.opaque,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

extension GoRouterLocation on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;

    return matchList.uri.toString();
  }
}
