import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/models/movie.dart';
import 'package:movie_verse_app/core/data/static/static_data.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/features/favourites/presentation/cubits/favorites_cubit.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: favoritesCubit,
      child: Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explorer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: const AssetImage(
                      'assets/images/profile.jpg',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: const Color(0xff151C2C),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 22.sp,
                    ),
                    hintText: 'Search movies...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Trending Searches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < StaticData.trendingSearches.length; i++)
                      _searchChip(StaticData.trendingSearches[i], i == 0),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '1,240 MOVIES',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 20.h,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: StaticData.searchResults.length,
                  itemBuilder: (_, index) =>
                      _movieCard(StaticData.searchResults[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _searchChip(String text, bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: selected ? kButtonsColor : const Color(0xff151C2C),
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

  Widget _movieCard(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  image: DecorationImage(
                    image: AssetImage(movie.imageAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1A1A),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: kButtonsColor, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        movie.rating,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final cubit = context.read<FavoritesCubit>();
                    final movieMap = {
                      'id': movie.id,
                      'title': movie.title,
                      'subtitle': movie.subtitle,
                      'rating': movie.rating,
                      'image': movie.imageAsset,
                    };
                    final isFav = cubit.isFavorite(movie.id);
                    return GestureDetector(
                      onTap: () => cubit.toggleFavorite(movieMap),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white.withValues(alpha: 0.7),
                        size: 18.r,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final cubit = context.read<FavoritesCubit>();
                    final movieMap = {
                      'id': movie.id,
                      'title': movie.title,
                      'subtitle': movie.subtitle,
                      'rating': movie.rating,
                      'image': movie.imageAsset,
                    };
                    final isInList = cubit.isInWatchlist(movie.id);
                    return GestureDetector(
                      onTap: () => cubit.toggleWatchlist(movieMap),
                      child: Icon(
                        isInList ? Icons.bookmark : Icons.bookmark_border,
                        color: isInList ? Colors.yellow : Colors.white.withValues(alpha: 0.7),
                        size: 18.r,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          movie.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          movie.subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
        ),
      ],
    );
  }
}
