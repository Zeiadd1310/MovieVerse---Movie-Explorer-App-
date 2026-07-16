import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_verse_app/core/utils/functions/snackbar_helper.dart';
import 'package:movie_verse_app/core/widgets/app_text_form_field.dart';
import 'package:movie_verse_app/core/widgets/custom_button.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_state.dart';
import 'package:movie_verse_app/features/auth/presentation/views/widgets/auth_screen_layout.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordEmailSent) {
          setState(() => _emailSent = true);
        } else if (state is AuthFailure) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      child: AuthScreenLayout(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.navigate_before,
                        size: 32.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 48.w),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/forgot.png',
                  width: 200.w,
                  height: 150.h,
                ),
                Text(
                  _emailSent ? 'Check Your Email' : 'Reset Password',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  _emailSent
                      ? 'We\'ve sent a password reset link to ${_emailController.text.trim()}. Check your inbox and follow the instructions.'
                      : 'Enter the email address associated with your account and we\'ll send you a link to reset your password.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff94A3B8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
                if (!_emailSent) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xffCBD5E1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextFormField(
                    controller: _emailController,
                    hintText: 'Enter your registered email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xff6B7280),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return CustomButton(
                        onTap: () => _submit(context),
                        isLoading: isLoading,
                        text: 'Send Reset Link',
                        width: double.infinity,
                        height: 56.h,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                        radius: 48,
                      );
                    },
                  ),
                ],
                SizedBox(height: 24.h),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16.sp,
                        color: const Color(0xffF9B81F),
                      ),
                      Text(
                        'Back to Sign In',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xffF9B81F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
