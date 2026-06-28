import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/Splash.png', fit: BoxFit.cover),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final verticalPadding = 24.h * 2;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - verticalPadding,
                  ),
                  child: Align(alignment: Alignment.center, child: child),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
