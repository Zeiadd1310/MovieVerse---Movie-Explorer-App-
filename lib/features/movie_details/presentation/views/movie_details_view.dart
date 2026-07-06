import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/models/movie.dart';
import 'package:movie_verse_app/core/data/static/static_data.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieId = GoRouterState.of(context).pathParameters['movieId'];
    final movie = StaticData.movieById(movieId ?? StaticData.interstellar.id);

    return Scaffold(
      backgroundColor: kDetailsBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, movie),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),
                      Text(
                        movie.title,
                        style: GoogleFonts.inter(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1.2,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: kButtonsColor, size: 20.sp),
                          SizedBox(width: 6.w),
                          Text(
                            movie.meta,
                            style: GoogleFonts.inter(
                              color: kSlateText,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      _sectionTitle('Overview'),
                      SizedBox(height: 12.h),
                      Text(
                        movie.overview,
                        style: GoogleFonts.inter(
                          color: kSlateText,
                          fontSize: 15.sp,
                          height: 1.7,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 35.h),
                      _buildCastSection(movie),
                      SizedBox(height: 140.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildFloatingWatchButton(context, movie.id),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MovieDetails movie) {
    return Stack(
      children: [
        Image.asset(
          movie.imageAsset,
          height: 500.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 500.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                kDetailsBackground,
              ],
            ),
          ),
        ),
        Positioned(
          top: 55.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIcon(Icons.arrow_back, onTap: () => context.pop()),
              Row(
                children: [
                  _circleIcon(Icons.favorite_border),
                  SizedBox(width: 15.w),
                  _circleIcon(Icons.share_outlined),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25.h,
          left: 20.w,
          child: Row(
            children: [
              for (int i = 0; i < movie.genreTags.length; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                _genreChip(movie.genreTags[i], isYellow: i == 0),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCastSection(MovieDetails movie) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Top Cast'),
            Text(
              'See All',
              style: GoogleFonts.inter(
                color: kButtonsColor,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [for (final member in movie.cast) _castAvatar(member)],
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22.sp),
      ),
    );
  }

  Widget _genreChip(String label, {bool isYellow = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isYellow ? kButtonsColor : const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isYellow ? Colors.black : Colors.white70,
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _castAvatar(CastMember member) {
    final parts = member.name.split(' ');
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38.r,
            backgroundColor: Colors.white12,
            backgroundImage: AssetImage(member.imageAsset),
          ),
          SizedBox(height: 12.h),
          Text(
            parts.first,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            parts.last,
            style: GoogleFonts.inter(color: kSlateText, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }

  Widget _buildFloatingWatchButton(BuildContext context, String movieId) {
    return Positioned(
      bottom: 30.h,
      left: 20.w,
      right: 20.w,
      child: GestureDetector(
        onTap: () => context.push(AppRouter.reviewRatingPath(movieId)),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: kButtonsColor,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: kButtonsColor.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_outlined, color: Colors.black, size: 32.sp),
              SizedBox(width: 8.w),
              Text(
                'Add Review',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
