import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_verse_app/core/utils/functions/app_preferences.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';

abstract class AppFlow {
  /// Resolves where the user should land after the splash screen.
  static Future<String> postSplashDestination() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return AppRouter.kMainLayout;
    }

    final hasLaunchedBefore = await AppPreferences.hasLaunchedBefore();
    return hasLaunchedBefore ? AppRouter.kSignInView : AppRouter.kSignUpView;
  }

  /// Resolves where unauthenticated users should be sent when hitting a protected route.
  static Future<String> unauthenticatedDestination() async {
    final hasLaunchedBefore = await AppPreferences.hasLaunchedBefore();
    return hasLaunchedBefore ? AppRouter.kSignInView : AppRouter.kSignUpView;
  }
}
