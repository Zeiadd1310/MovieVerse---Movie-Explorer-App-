import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/core/utils/functions/assets.dart';
import 'package:movie_verse_app/core/utils/functions/snackbar_helper.dart';
import 'package:movie_verse_app/core/widgets/app_text_form_field.dart';
import 'package:movie_verse_app/core/widgets/custom_button.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_state.dart';
import 'package:movie_verse_app/features/auth/presentation/views/widgets/auth_screen_layout.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          GoRouter.of(
            context,
          ).go(AppRouter.kMainLayout); // adjust to your actual home route
        } else if (state is AuthFailure) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      child: AuthScreenLayout(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetsData.logo, width: 128.w, height: 128.h),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Join Movie Explorer and start your cinematic journey.',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 400.w),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xffCBD5E1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      AppTextFormField(
                        controller: _nameController,
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xff6B7280),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xffCBD5E1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      AppTextFormField(
                        controller: _emailController,
                        hintText: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xff6B7280),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xffCBD5E1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      StatefulBuilder(
                        builder: (context, setInnerState) {
                          return AppTextFormField(
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            obscureText: _obscurePassword,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xff6B7280),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xff6B7280),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return CustomButton(
                            text: 'SIGN UP',
                            width: double.infinity,
                            height: 56.h,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            radius: 16.r,
                            isLoading: isLoading,
                            onTap: () => _submit(context),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xff475569),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff94A3B8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xff475569),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return CustomButton(
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
                                  borderColor: const Color(
                                    0xffF1F5F9,
                                  ).withOpacity(0.1),
                                  isLoading: isLoading,
                                  onTap: () => context
                                      .read<AuthCubit>()
                                      .signInWithGoogle(),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return CustomButton(
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
                                  borderColor: const Color(
                                    0xffF1F5F9,
                                  ).withOpacity(0.1),
                                  isLoading: isLoading,
                                  onTap: () => context
                                      .read<AuthCubit>()
                                      .signInWithFacebook(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: const Color(0xff94A3B8),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(
                        context,
                      ).go(AppRouter.kSignInView);
                    },
                    child: Text(
                      'Sign in instead',
                      style: TextStyle(
                        color: const Color(0xffF9B81F),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
