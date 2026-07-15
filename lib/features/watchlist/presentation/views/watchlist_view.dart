import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/features/favourites/presentation/cubits/favorites_cubit.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _toWatch = [
    {
      'title': 'Dune: Part Two',
      'subtitle': 'Sci-Fi, Adventure \u2022 2024',
      'rating': '8.9',
      'duration': '2h 46m',
      'image': 'assets/images/watchlist/Background+Shadow.png',
    },
    {
      'title': 'Interstellar',
      'subtitle': 'Sci-Fi, Drama \u2022 2014',
      'rating': '8.7',
      'duration': '2h 49m',
      'image': 'assets/images/watchlist/Background+Shadow (1).png',
    },
    {
      'title': 'The Batman',
      'subtitle': 'Action, Crime \u2022 2022',
      'rating': '7.8',
      'duration': '2h 56m',
      'image': 'assets/images/watchlist/Background+Shadow (2).png',
    },
    {
      'title': 'Pulp Fiction',
      'subtitle': 'Crime, Drama \u2022 1994',
      'rating': '8.9',
      'duration': '2h 34m',
      'image': 'assets/images/watchlist/Background+Shadow (3).png',
    },
  ];

  final List<Map<String, dynamic>> _watched = [
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _deleteItem(List<Map<String, dynamic>> data, int index) {
    setState(() => data.removeAt(index));
  }

  void _moveItem(List<Map<String, dynamic>> from, List<Map<String, dynamic>> to, int index) {
    setState(() {
      to.add(from.removeAt(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: favoritesCubit,
      child: Scaffold(
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
                    child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.r),
                  ),
                  Expanded(
                    child: Text(
                      'My Watchlist',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 23.sp,
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
              child: Container(
                decoration: BoxDecoration(
                  color: kSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color.fromARGB(255, 24, 24, 26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: kSlateText,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  tabs: const [
                    Tab(text: 'To Watch'),
                    Tab(text: 'Watched'),
                  ],
                ),
              ),
            ),
            Container(
              height: 1.h,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(_toWatch, false),
                  _buildList(_watched, true),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data, bool isWatched) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: data.length,
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemBuilder: (context, i) {
        final item = data[i];
        return Dismissible(
          key: ValueKey('$i-${item['title']}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteItem(data, i),
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 24.w),
            child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28.r),
          ),
          child: _buildRow(item, i, data, isWatched),
        );
      },
    );
  }

  Widget _buildRow(Map<String, dynamic> item, int index,
      List<Map<String, dynamic>> data, bool isWatched) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                item['image'] as String,
                width: 85.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 2.h,
              right: 2.w,
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final cubit = context.read<FavoritesCubit>();
                  final itemId = item['id'] as String? ?? item['title'] as String;
                  final isFav = cubit.isFavorite(itemId);
                  return GestureDetector(
                    onTap: () => cubit.toggleFavorite({
                      'id': itemId,
                      'title': item['title'] ?? '',
                      'subtitle': item['subtitle'] ?? '',
                      'rating': item['rating'] ?? '',
                      'image': item['image'] ?? '',
                    }),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white.withValues(alpha: 0.7),
                      size: 14.r,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                item['subtitle'] as String,
                style: GoogleFonts.poppins(
                  color: kSlateText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.star, color: kButtonsColor, size: 16.r),
                  SizedBox(width: 4.w),
                  Text(
                    item['rating'] as String,
                    style: GoogleFonts.poppins(
                      color: kButtonsColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(Icons.access_time, color: kSlateText, size: 16.r),
                  SizedBox(width: 4.w),
                  Text(
                    item['duration'] as String,
                    style: GoogleFonts.poppins(
                      color: kSlateText,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (!isWatched)
                    GestureDetector(
                      onTap: () => _moveItem(data, _watched, index),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: kButtonsColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Mark as Watched',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (isWatched)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Watched',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => _deleteItem(data, index),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 35, 35, 40),
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
            ],
          ),
        ),
      ],
    );
  }
}
