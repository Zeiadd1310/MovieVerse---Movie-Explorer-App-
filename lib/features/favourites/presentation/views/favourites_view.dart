import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _movies = [
    {
      'title': 'Dune: Part Two',
      'subtitle': 'Sci-Fi, Adventure \u2022 2024',
      'rating': '8.9',
      'duration': '2h 46m',
      'image': 'assets/images/favorites/Background.png',
    },
    {
      'title': 'Interstellar',
      'subtitle': 'Sci-Fi, Drama \u2022 2014',
      'rating': '8.7',
      'duration': '2h 49m',
      'image': 'assets/images/favorites/Background (1).png',
    },
    {
      'title': 'The Batman',
      'subtitle': 'Action, Crime \u2022 2022',
      'rating': '7.8',
      'duration': '2h 56m',
      'image': 'assets/images/favorites/Background (2).png',
    },
    {
      'title': 'Pulp Fiction',
      'subtitle': 'Crime, Drama \u2022 1994',
      'rating': '8.9',
      'duration': '2h 34m',
      'image': 'assets/images/favorites/Background (3).png',
    },
    {
      'title': 'The Dark Knight',
      'subtitle': 'Action, Thriller \u2022 2008',
      'rating': '9.0',
      'duration': '2h 32m',
      'image': 'assets/images/favorites/Background (4).png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _deleteMovie(int index) {
    setState(() => _movies.removeAt(index));
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
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'My Favorites',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: kButtonsColor, size: 24.r),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TabBar(
                controller: _tabController,
                indicatorColor: kButtonsColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: kButtonsColor,
                unselectedLabelColor: kSlateText,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Shows'),
                  Tab(text: 'Actors'),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMoviesList(),
                  _buildEmptyTab('No TV Shows yet'),
                  _buildEmptyTab('No Actors yet'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesList() {
    if (_movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, color: kSlateText, size: 48.r),
            SizedBox(height: 16.h),
            Text(
              'No favorites yet',
              style: GoogleFonts.poppins(color: kSlateText, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: _movies.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, i) => _buildCard(_movies[i], i),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    return Dismissible(
      key: ValueKey('fav-$index-${item['title']}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteMovie(index),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 24.r),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF171A21),
          borderRadius: BorderRadius.all(Radius.circular(48.r)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                item['image'] as String,
                width: 90.w,
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
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item['subtitle'] as String,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: kButtonsColor, size: 12.r),
                      SizedBox(width: 4.w),
                      Text(
                        item['rating'] as String,
                        style: GoogleFonts.poppins(
                          color: kButtonsColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.access_time, color: kSlateText, size: 12.r),
                      SizedBox(width: 4.w),
                      Text(
                        item['duration'] as String,
                        style: GoogleFonts.poppins(
                          color: kSlateText,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: () => _deleteMovie(index),
              child: Container(
                padding: EdgeInsets.all(8.r),
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 5, 15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTab(String text) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.poppins(color: kSlateText, fontSize: 16.sp),
      ),
    );
  }
}
