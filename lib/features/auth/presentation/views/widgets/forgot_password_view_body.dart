import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_verse_app/core/widgets/app_text_form_field.dart';
import 'package:movie_verse_app/core/widgets/custom_button.dart';

class ForgotPasswordViewBody extends StatelessWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/Splash.png', fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
          child: Container(
            height: 600.h,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06), // nearly transparent
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.2), // subtle border
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                // SizedBox(height: 16.h),
                Image.asset(
                  'assets/images/forgot.png',
                  width: 200.w,
                  height: 150.h,
                ),
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Enter the email address associated with your account and we\'ll send you a link to reset your password.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff94A3B8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xffCBD5E1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextFormField(
                  hintText: 'Enter your registered email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color(0xff6B7280),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  onTap: () {
                    // Handle reset password logic here
                  },
                  text: 'Send Reset Link',
                  width: double.infinity,
                  height: 56.h,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  radius: 48,
                ),
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
                        color: Color(0xffF9B81F),
                      ),
                      Text(
                        'Back to Sign In',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xffF9B81F),
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
      ],
    );
  }
}
