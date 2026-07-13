import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:movie_verse_app/features/search/presentation/cubits/search_state.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial || state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SearchFailure) {
              return _buildError(context, state.message);
            }

            if (state is SearchSuccess) {
              return Padding(
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
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: const Color(0xff151C2C),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            context.read<SearchCubit>().searchMovies(value),
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 22.sp,
                          ),
                          hintText: 'Search movies...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
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
                          for (final title in state.trendingSearches)
                            GestureDetector(
                              onTap: () => context
                                  .read<SearchCubit>()
                                  .searchMovies(title),
                              child: _searchChip(
                                title,
                                title.toLowerCase() ==
                                    state.query.toLowerCase(),
                              ),
                            ),
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
                          '${state.searchResults.length} MOVIES',
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
                      child: state.isSearching
                          ? const Center(child: CircularProgressIndicator())
                          : state.searchResults.isEmpty
                          ? state.query.isEmpty
                                ? const SizedBox()
                                : _buildNoResults()
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16.w,
                                    mainAxisSpacing: 20.h,
                                    childAspectRatio: 0.58,
                                  ),
                              itemCount: state.searchResults.length,
                              itemBuilder: (_, index) => _movieCard(
                                context,
                                state.searchResults[index],
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => context.read<SearchCubit>().retry(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: kButtonsColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Text(
        'No movies found',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 16.sp),
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

  Widget _movieCard(BuildContext context, MovieModel movie) {
    final releaseYear = movie.releaseDate.length >= 4
        ? movie.releaseDate.substring(0, 4)
        : movie.releaseDate;
    return GestureDetector(
      onTap: () =>
          context.push(AppRouter.movieDetailsPath(movie.id.toString())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    image: movie.posterPath.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: movie.posterPath.isNotEmpty ? null : Colors.grey,
                  ),
                  child: movie.posterPath.isEmpty
                      ? const Center(
                          child: Icon(Icons.movie, color: Colors.white),
                        )
                      : null,
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff1A1A1A),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: kButtonsColor, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
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
            releaseYear,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
