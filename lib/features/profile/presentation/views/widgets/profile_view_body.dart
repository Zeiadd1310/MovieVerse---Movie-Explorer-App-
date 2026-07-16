import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/profile/presentation/views/signout_view.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Column(
                  children: [
                    _ProfileSection(),
                    SizedBox(height: 40.h),
                    _AccountSettingsSection(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
            child: _SignOutButton(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          color: const Color(0xFF0E1015).withValues(alpha: 0.8),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  _IconCircle(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => context.canPop() ? context.pop() : null,
                  ),
                  Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.splineSans(
                        color: ProfileViewBody._textPrimary,
                        fontSize: 22.sp,
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
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 40.w,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(icon, color: ProfileViewBody._textPrimary, size: 18.sp),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128.w,
                height: 128.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kButtonsColor.withValues(alpha: 0.2),
                      spreadRadius: 4,
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/256?img=13'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 4.h,
                right: 4.w,
                child: Container(
                  width: 29.w,
                  height: 29.w,
                  decoration: BoxDecoration(
                    color: kButtonsColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ProfileViewBody._backgroundColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: const Color(0xFF0E1015),
                    size: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Alex Rivers',
            style: GoogleFonts.splineSans(
              color: ProfileViewBody._textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.6,
            ),
          ),
          Text(
            '@alexrivers',
            style: GoogleFonts.splineSans(
              color: kSlateText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24.h),
          Material(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(24.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: () => context.push(AppRouter.editProfilePath()),
              child: Container(
                height: 44.h,
                constraints: BoxConstraints(minWidth: 140.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.center,
                child: Text(
                  'Edit Profile',
                  style: GoogleFonts.splineSans(
                    color: ProfileViewBody._textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountSettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                'ACCOUNT SETTINGS',
                style: GoogleFonts.splineSans(
                  color: ProfileViewBody._textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _SettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Push alerts and email preferences',
            onTap: () => context.push(AppRouter.notificationsPath()),
          ),
          _SettingsItem(
            icon: Icons.lock_outline,
            title: 'Privacy',
            subtitle: 'Password settings',
            onTap: () => context.push(AppRouter.privacyPath()),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: kButtonsColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: kButtonsColor, size: 20.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.splineSans(
                        color: ProfileViewBody._textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.splineSans(
                        color: kSlateText,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: kSlateText, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Material(
        color: kButtonsColor,
        borderRadius: BorderRadius.circular(24.r),
        elevation: 8,
        shadowColor: kButtonsColor.withValues(alpha: 0.4),
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () => SignOutDialog.show(context),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: const Color(0xFF0F172A), size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Sign Out',
                  style: GoogleFonts.splineSans(
                    color: const Color(0xFF0F172A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
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
