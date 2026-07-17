import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/snackbar_helper.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_state.dart';

class PrivacyViewBody extends StatefulWidget {
  const PrivacyViewBody({super.key});

  @override
  State<PrivacyViewBody> createState() => _PrivacyViewBodyState();
}

class _PrivacyViewBodyState extends State<PrivacyViewBody> {
  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);

  final _formKey = GlobalKey<FormState>();
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

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordChanged) {
          SnackbarHelper.showSuccess(context, 'Password changed successfully.');
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        } else if (state is AuthFailure) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      child: Scaffold(
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
                                  Icons.arrow_back_ios_new,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PasswordField(
                        label: 'Current Password',
                        controller: _currentPasswordController,
                        obscure: _obscureCurrent,
                        onToggleObscure: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),
                      _PasswordField(
                        label: 'New Password',
                        controller: _newPasswordController,
                        obscure: _obscureNew,
                        onToggleObscure: () =>
                            setState(() => _obscureNew = !_obscureNew),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),
                      _PasswordField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        obscure: _obscureConfirm,
                        onToggleObscure: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: Material(
                                color: kButtonsColor,
                                borderRadius: BorderRadius.circular(48.r),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(48.r),
                                  onTap: isLoading
                                      ? null
                                      : () => _submit(context),
                                  child: Center(
                                    child: isLoading
                                        ? SizedBox(
                                            width: 22.w,
                                            height: 22.h,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.black,
                                                ),
                                          )
                                        : Text(
                                            'Update Password',
                                            style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String? Function(String?)? validator;

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
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            textAlignVertical: TextAlignVertical.center,
            style: GoogleFonts.inter(
              color: const Color(0xFFF1F5F9),
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFF171A21),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 17.w,
                vertical: 16.h,
              ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.r),
                borderSide: const BorderSide(color: Color(0xFF2D323D)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.r),
                borderSide: const BorderSide(color: Color(0xFF2D323D)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.r),
                borderSide: BorderSide(color: kButtonsColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.r),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
