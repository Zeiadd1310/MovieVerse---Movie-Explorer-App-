import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/features/auth/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const kSplashView = '/splashView';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
    ],
  );
}
