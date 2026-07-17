import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/services/notification_prefs.dart';
import 'package:movie_verse_app/core/services/notification_service.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.init();
  unawaited(notificationPrefs.ensureLoaded());

  runApp(const MovieVerseApp());
}

class MovieVerseApp extends StatelessWidget {
  const MovieVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 908),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        ),
      ),
    );
  }
}
