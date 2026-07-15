import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/models/movie.dart';
import 'package:movie_verse_app/core/data/static/static_data.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final banner = StaticData.featuredBanner;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1015),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.movie, color: kButtonsColor, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'MovieExplorer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _iconButton(Icons.search),
                        SizedBox(width: 10.w),
                        _iconButton(Icons.notifications_none),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                _buildBanner(banner),
                SizedBox(height: 30.h),
                _sectionTitle('Categories'),
                SizedBox(height: 15.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < StaticData.categories.length; i++)
                        _categoryItem(StaticData.categories[i], i == 0),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                _sectionTitle('Trending Now'),
                SizedBox(height: 18.h),
                SizedBox(
                  height: 270.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: StaticData.trendingMovies.length,
                    separatorBuilder: (_, index) => SizedBox(width: 15.w),
                    itemBuilder: (_, index) =>
                        _trendingCard(StaticData.trendingMovies[index]),
                  ),
                ),
                SizedBox(height: 30.h),
                _sectionTitle('Popular Movies'),
                SizedBox(height: 18.h),
                for (int i = 0; i < StaticData.popularMovies.length; i++) ...[
                  if (i > 0) SizedBox(height: 15.h),
                  _popularMovieTile(context, StaticData.popularMovies[i]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Icon(icon, color: Colors.white, size: 18.sp),
    );
  }

  Widget _buildBanner(({String image, String badge, String title}) banner) {
    return Container(
      height: 210.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(28.r),
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        image: DecorationImage(
          image: AssetImage(banner.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: kButtonsColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                banner.badge,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              banner.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: kButtonsColor,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, color: Colors.black, size: 18.sp),
                      SizedBox(width: 5.w),
                      Text(
                        'Watch Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 44.r,
                  width: 44.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(
            color: kButtonsColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(String text, bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: selected ? kButtonsColor : kSurfaceColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _trendingCard(Movie movie) {
    return Container(
      width: 150.w,
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                child: Image.asset(
                  movie.imageAsset,
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: kButtonsColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    movie.rating,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  movie.subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _popularMovieTile(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () => context.push(AppRouter.movieDetailsPath(movie.id)),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.asset(
                movie.imageAsset,
                height: 85.h,
                width: 65.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    movie.genres ?? movie.subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: kButtonsColor, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        movie.rating,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.bookmark_border, color: kButtonsColor, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
