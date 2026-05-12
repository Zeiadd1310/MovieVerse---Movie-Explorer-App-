import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:movie_verse_app/features/auth/presentation/views/splash_view.dart';
import 'package:movie_verse_app/features/movie_details/presentation/views/movie_details_view.dart';
import 'package:movie_verse_app/features/movie_details/presentation/views/review_rating_screen.dart';

abstract class AppRouter {
  static const kSplashView = '/splashView';
  static const kSignUpView = '/signUpView';
  static const kSignInView = '/signInView';
  static const kMovieDetailsView = '/movieDetailsView';
  static const kReviewRatingScreen = '/reviewRatingScreen';
  static const kForgotPasswordView = '/forgotPasswordView';

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
      GoRoute(
        path: kMovieDetailsView,
        builder: (context, state) => const MovieDetailsView(),
      ),
      GoRoute(
        path: kReviewRatingScreen,
        builder: (context, state) => const ReviewRatingScreen(),
      ),
      GoRoute(
        path: kForgotPasswordView,
        builder: (context, state) => const ForgotPasswordView(),
      ),
    ],
  );
}
