import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/favourites/presentation/cubits/favorites_cubit.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
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
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [Tab(text: 'Movies')],
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildMoviesList()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesList() {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading || state is FavoritesInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! FavoritesUpdated) {
          return const SizedBox.shrink();
        }

        final movies = state.favorites;

        if (movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, color: kSlateText, size: 48.r),
                SizedBox(height: 16.h),
                Text(
                  'No favorites yet',
                  style: GoogleFonts.poppins(
                    color: kSlateText,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          itemCount: movies.length,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, i) => _buildCard(movies[i]),
        );
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return Dismissible(
      key: ValueKey('fav-${item['id']}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        favoritesCubit.removeFavoriteById(item['id'].toString());
      },
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 24.r),
      ),
      child: GestureDetector(
        onTap: () =>
            context.push(AppRouter.movieDetailsPath(item['id'].toString())),
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
                child: Image.network(
                  item['image'] as String? ?? '',
                  width: 90.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90.w,
                    height: 120.h,
                    color: const Color(0xFF1E232C),
                    child: Icon(Icons.movie, color: Colors.grey, size: 30.r),
                  ),
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
                        if (item['duration'] != null) ...[
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.access_time,
                            color: kSlateText,
                            size: 12.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item['duration'] as String,
                            style: GoogleFonts.poppins(
                              color: kSlateText,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  favoritesCubit.removeFavoriteById(item['id'].toString());
                },
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B050F),
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
      ),
    );
  }
}
