import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

class WatchedView extends StatefulWidget {
  const WatchedView({super.key});

  @override
  State<WatchedView> createState() => _WatchedViewState();
}

class _WatchedViewState extends State<WatchedView> {
  final List<Map<String, dynamic>> _data = [
    {
      'title': 'Oppenheimer',
      'subtitle': 'Biography, Drama \u2022 2023',
      'rating': '8.4',
      'duration': '3h 0m',
      'image': 'assets/images/watched/Background+Shadow.png',
    },
    {
      'title': 'John Wick: Chapter 4',
      'subtitle': 'Action, Thriller \u2022 2023',
      'rating': '7.7',
      'duration': '2h 49m',
      'image': 'assets/images/watched/Background+Shadow (1).png',
    },
    {
      'title': 'The Dark Knight',
      'subtitle': 'Action, Crime \u2022 2008',
      'rating': '9.0',
      'duration': '2h 32m',
      'image': 'assets/images/watched/Background+Shadow (2).png',
    },
    {
      'title': 'Inception',
      'subtitle': 'Sci-Fi, Action \u2022 2010',
      'rating': '8.8',
      'duration': '2h 28m',
      'image': 'assets/images/watched/Background+Shadow (3).png',
    },
  ];

  void _deleteItem(int index) {
    setState(() => _data.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1015),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.r),
                  Expanded(
                    child: Text(
                      'Watched Movies',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: kButtonsColor, size: 24.r),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                itemCount: _data.length,
                separatorBuilder: (_, _) => SizedBox(height: 24.h),
                itemBuilder: (context, i) {
                  final item = _data[i];
                  return Dismissible(
                    key: ValueKey('$i-${item['title']}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteItem(i),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 24.w),
                      child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28.r),
                    ),
                    child: _buildRow(item, i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> item, int index) {
    return SizedBox(
      height: 120.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              item['image'] as String,
              width: 120.w,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item['title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.poppins(color: kSlateText, fontSize: 22.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.star, color: kButtonsColor, size: 22.r),
                    SizedBox(width: 4.w),
                    Text(
                      item['rating'] as String,
                      style: GoogleFonts.poppins(
                        color: kButtonsColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.access_time, color: kSlateText, size: 22.r),
                    SizedBox(width: 4.w),
                    Text(
                      item['duration'] as String,
                      style: GoogleFonts.poppins(color: kSlateText, fontSize: 22.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: kSlateText, size: 20.r),
            color: kSurfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            onSelected: (v) {
              if (v == 'delete') {
                _deleteItem(index);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.redAccent, size: 18.r),
                    SizedBox(width: 10.w),
                    Text(
                      'Remove',
                      style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
