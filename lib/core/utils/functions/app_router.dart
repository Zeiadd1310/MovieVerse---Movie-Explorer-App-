import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/splash_view.dart';


//nav bar 
import 'package:movie_verse_app/features/home/presentation/views/home_view.dart';
//import 'package:movie_verse_app/features/explore/presentation/views/explore_view.dart';
import 'package:movie_verse_app/features/watchlist/presentation/views/watchlist_view.dart';
import 'package:movie_verse_app/features/profile/presentation/views/profile_view.dart';

abstract class AppRouter {
  static const kSplashView = '/splashView';
  static const kSignUpView = '/signUpView';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kSignUpView,
        builder: (context, state) => const SignUpView(),
      ),
    ],
  );
}
