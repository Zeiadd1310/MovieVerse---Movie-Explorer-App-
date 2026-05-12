import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const kSplashView = '/splashView';
  static const kSignUpView = '/signUpView';
  static const kSignInView = '/signInView';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kSignUpView,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: kSignInView,
        builder: (context, state) => const SignInView(),
      ),
    ],
  );
}
