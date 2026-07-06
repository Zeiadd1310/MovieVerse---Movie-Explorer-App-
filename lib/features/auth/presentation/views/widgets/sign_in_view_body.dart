import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/core/utils/functions/assets.dart';
import 'package:movie_verse_app/core/widgets/app_text_form_field.dart';
import 'package:movie_verse_app/core/widgets/custom_button.dart';
import 'package:movie_verse_app/features/auth/presentation/views/widgets/auth_screen_layout.dart';

class SignInViewBody extends StatelessWidget {
  const SignInViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetsData.logo, width: 128.w, height: 128.h),
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Sign in to continue exploring your favorite movies and series.',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xffCBD5E1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                AppTextFormField(
                  hintText: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email, color: Color(0xff6B7280)),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xffCBD5E1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(
                          context,
                        ).push(AppRouter.kForgotPasswordView);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xffF9B81F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                AppTextFormField(
                  hintText: 'Enter your password',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock, color: Color(0xff6B7280)),
                  suffixIcon: Icon(Icons.visibility, color: Color(0xff6B7280)),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  onTap: () {
                    GoRouter.of(context).pushReplacement(AppRouter.kMainLayout);
                  },
                  text: 'SIGN IN',
                  width: double.infinity,
                  height: 56.h,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  radius: 16.r,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Color(0xff475569)),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'OR CONTINUE WITH',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xff94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(height: 1, color: Color(0xff475569)),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        icon: Icons.g_mobiledata,
                        iconSize: 28,
                        text: 'Google',
                        width: double.infinity,
                        height: 50.h,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        radius: 16.r,
                        color: kPrimaryColor,
                        borderColor: Color(0xffF1F5F9).withOpacity(0.1),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomButton(
                        text: 'Facebook',
                        width: double.infinity,
                        height: 50.h,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        radius: 16.r,
                        icon: Icons.facebook,
                        iconSize: 25,
                        color: kPrimaryColor,
                        borderColor: Color(0xffF1F5F9).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(
                  color: Color(0xff94A3B8),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushReplacement(AppRouter.kSignUpView);
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xffF9B81F),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
