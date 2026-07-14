import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_flow.dart';
import 'package:movie_verse_app/core/utils/functions/app_preferences.dart';
import 'package:movie_verse_app/core/utils/functions/assets.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentProgress = 0.0;
  String _message = 'Syncing Global Box Office Data';
  final Random _random = Random();

  final List<(double, String)> _steps = [
    (0.20, 'Syncing Global Box Office Data'),
    (0.45, 'Loading Movie Database'),
    (0.64, 'Fetching Trending Films'),
    (0.80, 'Preparing Your Experience'),
    (1.00, 'Initializing Cinematic Experience'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _runLoadingSequence();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runLoadingSequence() async {
    for (final (progress, message) in _steps) {
      final delay = 400 + _random.nextInt(800);
      await Future.delayed(Duration(milliseconds: delay));
      if (!mounted) return;

      _animation = Tween<double>(
        begin: _currentProgress,
        end: progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _animation.addListener(() {
        setState(() {
          _currentProgress = _animation.value;
        });
      });

      setState(() => _message = message);
      _currentProgress = progress;

      await _controller.forward(from: 0).orCancel.catchError((_) {});
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final destination = await AppFlow.postSplashDestination();
    await AppPreferences.markLaunched();
    if (!mounted) return;

    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/Splash.png', fit: BoxFit.cover),
          // Content
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsData.logo, width: 120.w, height: 120.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'MOVIE',
                        style: TextStyle(
                          color: const Color(0xFFF1F5F9),
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      TextSpan(
                        text: 'VERSE',
                        style: TextStyle(
                          color: kButtonsColor,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'PREMIUM MOVIE EXPLORER',
                  style: TextStyle(
                    color: kSlateText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 64.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _message,
                        style: TextStyle(
                          color: kButtonsColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(_currentProgress * 100).toInt()}%',
                        style: TextStyle(
                          color: kButtonsColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: _currentProgress,
                      minHeight: 4.h,
                      backgroundColor: kPrimaryColor,
                      valueColor: AlwaysStoppedAnimation<Color>(kButtonsColor),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'INITIALIZING CINEMATIC EXPERIENCE...',
                  style: TextStyle(
                    color: kSlateText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
