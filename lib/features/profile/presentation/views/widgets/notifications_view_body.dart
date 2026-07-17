import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/services/notification_prefs.dart';

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key});

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody> {
  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);
  static const _trackColor = Color(0xFF334155);

  bool _newReleases = notificationPrefs.newReleases;
  bool _recommendations = notificationPrefs.recommendations;
  bool _watchlistReminders = notificationPrefs.watchlistReminders;

  @override
  void initState() {
    super.initState();
    notificationPrefs.ensureLoaded().then((_) {
      if (!mounted) return;
      setState(() {
        _newReleases = notificationPrefs.newReleases;
        _recommendations = notificationPrefs.recommendations;
        _watchlistReminders = notificationPrefs.watchlistReminders;
      });
    });
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
                        InkWell(
                          onTap: () => context.pop(),
                          child: Icon(Icons.arrow_back_ios_new, size: 22.sp),
                        ),

                        SizedBox(width: 16.w),
                        Text(
                          'Notification Settings',
                          style: GoogleFonts.splineSans(
                            color: _textPrimary,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVITY & RELEASES',
                    style: GoogleFonts.splineSans(
                      color: kSlateText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      children: [
                        _NotificationTile(
                          title: 'New Releases',
                          subtitle: 'When movies you follow are available',
                          value: _newReleases,
                          trackColor: _trackColor,
                          showDivider: true,
                          onChanged: (value) {
                            setState(() => _newReleases = value);
                            notificationPrefs.setNewReleases(value);
                          },
                        ),
                        _NotificationTile(
                          title: 'Recommendations',
                          subtitle: "Movies we think you'll love",
                          value: _recommendations,
                          trackColor: _trackColor,
                          showDivider: true,
                          onChanged: (value) {
                            setState(() => _recommendations = value);
                            notificationPrefs.setRecommendations(value);
                          },
                        ),
                        _NotificationTile(
                          title: 'Watchlist Reminders',
                          subtitle: 'Remind me to watch saved movies',
                          value: _watchlistReminders,
                          trackColor: _trackColor,
                          showDivider: false,
                          onChanged: (value) {
                            setState(() => _watchlistReminders = value);
                            notificationPrefs.setWatchlistReminders(value);
                          },
                        ),
                      ],
                    ),
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.trackColor,
    required this.showDivider,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final Color trackColor;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFF1E293B)))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.splineSans(
                    color: const Color(0xFFF1F5F9),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.splineSans(
                    color: kSlateText,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            inactiveThumbColor: Colors.white,
            activeTrackColor: kButtonsColor,
            inactiveTrackColor: trackColor,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
