import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/favourites/presentation/cubits/favorites_cubit.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    favoritesCubit.loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20.r,
                      ),
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
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading ||
                        state is FavoritesInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is! FavoritesUpdated) {
                      return const SizedBox.shrink();
                    }

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildToWatchList(state.watchlist),
                        _buildWatchedList(state.watched),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToWatchList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, color: kSlateText, size: 48.r),
            SizedBox(height: 16.h),
            Text(
              'No movies to watch',
              style: GoogleFonts.poppins(color: kSlateText, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: data.length,
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemBuilder: (context, i) {
        final item = data[i];
        return Dismissible(
          key: ValueKey('towatch-${item['id']}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            favoritesCubit.removeWatchlistById(item['id'].toString());
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 24.w),
            child: Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 28.r,
            ),
          ),
          child: GestureDetector(
            onTap: () =>
                context.push(AppRouter.movieDetailsPath(item['id'].toString())),
            child: _buildRow(item, false),
          ),
        );
      },
    );
  }

  Widget _buildWatchedList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: kSlateText, size: 48.r),
            SizedBox(height: 16.h),
            Text(
              'No watched movies yet',
              style: GoogleFonts.poppins(color: kSlateText, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: data.length,
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemBuilder: (context, i) {
        final item = data[i];
        return Dismissible(
          key: ValueKey('watched-${item['id']}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            favoritesCubit.removeWatchedById(item['id'].toString());
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 24.w),
            child: Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 28.r,
            ),
          ),
          child: GestureDetector(
            onTap: () =>
                context.push(AppRouter.movieDetailsPath(item['id'].toString())),
            child: _buildRow(item, true),
          ),
        );
      },
    );
  }

  Widget _buildRow(Map<String, dynamic> item, bool isWatched) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                item['image'] as String? ?? '',
                width: 85.w,
                height: 120.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 85.w,
                  height: 120.h,
                  color: const Color(0xFF1E232C),
                  child: Icon(Icons.movie, color: Colors.grey, size: 30.r),
                ),
              ),
            ),
            Positioned(
              top: 2.h,
              right: 2.w,
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final isFav = favoritesCubit.isFavorite(
                    item['id'].toString(),
                  );
                  return GestureDetector(
                    onTap: () => favoritesCubit.toggleFavorite(item),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav
                          ? Colors.red
                          : Colors.white.withValues(alpha: 0.7),
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
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4.h),
              Text(
                item['subtitle'] as String,
                style: GoogleFonts.poppins(color: kSlateText, fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.star, color: kButtonsColor, size: 14.r),
                  SizedBox(width: 4.w),
                  Text(
                    item['rating'] as String,
                    style: GoogleFonts.poppins(
                      color: kButtonsColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item['duration'] != null) ...[
                    SizedBox(width: 12.w),
                    Icon(Icons.access_time, color: kSlateText, size: 14.r),
                    SizedBox(width: 4.w),
                    Text(
                      item['duration'] as String,
                      style: GoogleFonts.poppins(
                        color: kSlateText,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12.h),
              if (!isWatched)
                GestureDetector(
                  onTap: () {
                    favoritesCubit.moveToWatched(item);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
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
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
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
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            if (isWatched) {
              favoritesCubit.removeWatchedById(item['id'].toString());
            } else {
              favoritesCubit.removeWatchlistById(item['id'].toString());
            }
          },
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: const Color(0xFF0B050F),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_outline, color: Colors.white, size: 20.r),
          ),
        ),
      ],
    );
  }
}
