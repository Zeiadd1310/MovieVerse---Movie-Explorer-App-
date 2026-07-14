import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/utils/functions/api_service.dart';
import 'package:movie_verse_app/core/utils/functions/app_flow.dart';
import 'package:movie_verse_app/core/utils/functions/go_router_refresh_stream.dart';
import 'package:movie_verse_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/splash_view.dart';
import 'package:movie_verse_app/features/home/data/repos/home_repo_impl.dart';
import 'package:movie_verse_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:movie_verse_app/features/home/presentation/views/home_view.dart';
import 'package:movie_verse_app/features/layout/main_layout.dart';
import 'package:movie_verse_app/features/movie_details/presentation/views/movie_details_view.dart';
import 'package:movie_verse_app/features/movie_details/presentation/views/review_rating_screen.dart';
import 'package:movie_verse_app/features/search/data/repos/search_repo_impl.dart';
import 'package:movie_verse_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:movie_verse_app/features/search/presentation/views/search_view.dart';

abstract class AppRouter {
  static const kSplashView = '/';
  static const kSignUpView = '/signUpView';
  static const kSignInView = '/signInView';
  static const kForgotPasswordView = '/forgotPasswordView';
  static const kMainLayout = '/home';
  static const kExplore = '/explore';
  static const kWatchlist = '/watchlist';
  static const kProfile = '/profile';

  static String movieDetailsPath([String movieId = 'interstellar']) =>
      '$kMainLayout/movie/$movieId';

  static String reviewRatingPath([String movieId = 'interstellar']) =>
      '${movieDetailsPath(movieId)}/review';

  static final _authRefresh =
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());

  static bool _isAuthRoute(String location) {
    return location == kSignInView ||
        location == kSignUpView ||
        location == kForgotPasswordView;
  }

  static final router = GoRouter(
    initialLocation: kSplashView,
    refreshListenable: _authRefresh,
    redirect: (context, state) async {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final location = state.matchedLocation;
      final isSplash = location == kSplashView;
      final isAuthRoute = _isAuthRoute(location);

      if (isSplash) return null;

      if (!isLoggedIn && !isAuthRoute) {
        return AppFlow.unauthenticatedDestination();
      }

      if (isLoggedIn && isAuthRoute) {
        return kMainLayout;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: kSignUpView,
        builder: (context, state) => const SignUpView(),
      ),

      GoRoute(
        path: kSignInView,
        builder: (context, state) => const SignInView(),
      ),

      GoRoute(
        path: kForgotPasswordView,
        builder: (context, state) => const ForgotPasswordView(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kMainLayout,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      HomeCubit(HomeRepoImpl(ApiService()))..getPopularMovies(),
                  child: const HomeView(),
                ),
                routes: [
                  GoRoute(
                    path: 'movie/:movieId',
                    builder: (context, state) => const MovieDetailsView(),
                    routes: [
                      GoRoute(
                        path: 'review',
                        builder: (context, state) => const ReviewRatingScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kExplore,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      SearchCubit(SearchRepoImpl(ApiService()))
                        ..loadSearchData(),
                  child: const SearchView(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kWatchlist,
                builder: (context, state) =>
                    const TabPlaceholder(title: 'Watchlist'),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kProfile,
                builder: (context, state) =>
                    const TabPlaceholder(title: 'Profile'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
