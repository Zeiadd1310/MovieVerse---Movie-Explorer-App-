import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/profile/data/models/user_profile_model.dart';
import 'package:movie_verse_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:movie_verse_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:movie_verse_app/features/profile/presentation/views/signout_view.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final profile = (state as ProfileLoaded).profile;

          return Column(
            children: [
              _Header(),
              Divider(color: Color.fromARGB(21, 255, 255, 255)),
              SizedBox(height: 10.h),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 32.h),
                    child: Column(
                      children: [
                        _ProfileSection(profile: profile),
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
          );
        },
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
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
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
              image: DecorationImage(
                image:
                    (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                    ? NetworkImage(profile.photoUrl!)
                    : const NetworkImage('https://i.pravatar.cc/256?img=13'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            profile.fullName,
            style: GoogleFonts.splineSans(
              color: ProfileViewBody._textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.6,
            ),
          ),
          Text(
            profile.email,
            style: GoogleFonts.splineSans(
              color: kSlateText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (profile.bio.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: GoogleFonts.splineSans(color: kSlateText, fontSize: 13.sp),
            ),
          ],
          SizedBox(height: 24.h),
          Material(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(24.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: () async {
                await context.push(AppRouter.editProfilePath());
                if (context.mounted) {
                  context.read<ProfileCubit>().loadProfile(
                    FirebaseAuth.instance.currentUser!.uid,
                  );
                }
              },
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
