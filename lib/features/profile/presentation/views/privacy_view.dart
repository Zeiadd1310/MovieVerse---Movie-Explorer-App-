import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

class PrivacyView extends StatefulWidget {
  const PrivacyView({super.key});

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: _backgroundColor.withValues(alpha: 0.8),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => context.pop(),
                              child: Icon(
                                Icons.arrow_back,
                                color: _textPrimary,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Privacy Settings',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.45,
                            ),
                          ),
                        ),
                        SizedBox(width: 40.w),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PasswordField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    obscure: _obscureCurrent,
                    onToggleObscure: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  SizedBox(height: 32.h),
                  _PasswordField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    obscure: _obscureNew,
                    onToggleObscure: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  SizedBox(height: 32.h),
                  _PasswordField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscure: _obscureConfirm,
                    onToggleObscure: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.splineSans(
              color: kButtonsColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFF171A21),
              borderRadius: BorderRadius.circular(48.r),
              border: Border.all(color: const Color(0xFF2D323D)),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F5F9),
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 17.w),
                hintText: 'Enter your password',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF475569),
                  fontSize: 16.sp,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: kSlateText,
                  size: 16.sp,
                ),
                suffixIcon: IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(
                    obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: kSlateText,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
