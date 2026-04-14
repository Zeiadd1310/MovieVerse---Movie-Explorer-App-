import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movie_verse_app/core/utils/functions/assets.dart';
import 'package:movie_verse_app/features/auth/presentation/views/sign_up_view.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignUpView()),
    );
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
                Image.asset(AssetsData.logo),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'MOVIE',
                        style: TextStyle(
                          color: Color(0xFFF1F5F9),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      TextSpan(
                        text: 'VERSE',
                        style: TextStyle(
                          color: Color(0xFFF9B81F),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'PREMIUM MOVIE EXPLORER',
                  style: TextStyle(
                    color: Color(0xff94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 64),
                // Syncing label + percentage
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _message,
                        style: const TextStyle(
                          color: Color(0xffF9B81F),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(_currentProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xffF9B81F),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _currentProgress,
                      minHeight: 4,
                      backgroundColor: const Color(0xff1E293B),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xffF9B81F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'INITIALIZING CINEMATIC EXPERIENCE...',
                  style: TextStyle(
                    color: Color(0xff94A3B8),
                    fontSize: 12,
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
