import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';

void main() {
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
