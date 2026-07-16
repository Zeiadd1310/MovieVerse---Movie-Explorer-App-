import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

/// The "Sign Out" confirmation modal from the Figma "Sign Out (Midnight
/// Theme)" screen. Call [SignOutDialog.show] to display it above whatever
/// screen is currently on-screen (blurred/dimmed to match the design).
class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: 'Sign Out',
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignOutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: const Color(0xFF0E1015).withValues(alpha: 0.8),
          padding: EdgeInsets.all(16.w),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 384.w),
              padding: EdgeInsets.all(32.r),
              decoration: BoxDecoration(
                color: const Color(0xFF171A21),
                borderRadius: BorderRadius.circular(48.r),
                border: Border.all(color: kButtonsColor.withValues(alpha: 0.2)),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 50, offset: Offset(0, 25)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: kButtonsColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.logout, color: kButtonsColor, size: 27.sp),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF0F2F5),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.6,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Are you sure you want to sign out? You will need to '
                    'enter your credentials to log back into your account.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF0F2F5).withValues(alpha: 0.8),
                      fontSize: 16.sp,
                      height: 26 / 16,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: kButtonsColor,
                      borderRadius: BorderRadius.circular(999.r),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999.r),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Text(
                            'Sign Out',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0E1015),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 17.h),
                        side: BorderSide(color: kButtonsColor.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFF0F2F5),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
