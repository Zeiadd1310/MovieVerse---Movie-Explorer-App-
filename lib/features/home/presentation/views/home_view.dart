import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/favourites/presentation/cubits/favorites_cubit.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';
import 'package:movie_verse_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:movie_verse_app/features/home/presentation/cubits/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: favoritesCubit,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeFailure) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is HomeSuccess) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 14.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.movie,
                                  color: kButtonsColor,
                                  size: 20.sp,
                                ),
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
                                _iconButton(
                                  Icons.search,
                                  onTap: () => context.push(AppRouter.kExplore),
                                ),
                                SizedBox(width: 10.w),
                                _iconButton(Icons.notifications_none),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        _buildBanner(context, state.featuredMovie),
                        SizedBox(height: 30.h),
                        _sectionTitle('Categories'),
                        SizedBox(height: 15.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final genre in state.genres)
                                GestureDetector(
                                  onTap: () => context
                                      .read<HomeCubit>()
                                      .selectGenre(genre.id),
                                  child: _categoryItem(
                                    genre.name,
                                    genre.id == state.selectedGenreId,
                                  ),
                                ),
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
                            itemCount: state.trendingMovies.length,
                            separatorBuilder: (_, index) =>
                                SizedBox(width: 15.w),
                            itemBuilder: (_, index) =>
                                _trendingCardApi(state.trendingMovies[index]),
                          ),
                        ),
                        SizedBox(height: 18.h),

                        _sectionTitle('Popular Movies'),
                        SizedBox(height: 18.h),
                        Column(
                          children: state.movies
                              .map(
                                (movie) => Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: _popularMovieTileApi(
                                    context,
                                    movie,
                                    state.favoriteMovieIds.contains(movie.id),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: kSurfaceColor,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, MovieModel? featuredMovie) {
    if (featuredMovie == null) {
      return Container(
        height: 210.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(28.r),
        ),
      );
    }

    final imageProvider = NetworkImage(
      'https://image.tmdb.org/t/p/w500${featuredMovie.backdropPath.isNotEmpty ? featuredMovie.backdropPath : featuredMovie.posterPath}',
    );
    final title = featuredMovie.title;

    return Container(
      height: 210.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
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
                'TRENDING',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => context.push(
                AppRouter.movieDetailsPath(featuredMovie.id.toString()),
              ),
              child: Container(
                width: 155.w,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
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

  Widget _trendingCardApi(MovieModel movie) {
    final releaseYear = movie.releaseDate.length >= 4
        ? movie.releaseDate.substring(0, 4)
        : movie.releaseDate;
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
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200.h,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.movie),
                  ),
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
                    movie.voteAverage.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                left: 8.w,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final cubit = context.read<FavoritesCubit>();
                    final movieMap = movie.toFavoriteMap();
                    final isFav = cubit.isFavorite(movie.id.toString());
                    return GestureDetector(
                      onTap: () => cubit.toggleFavorite(movieMap),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav
                            ? Colors.red
                            : Colors.white.withValues(alpha: 0.7),
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
                    final movieMap = movie.toFavoriteMap();
                    final isInList = cubit.isInWatchlist(movie.id.toString());
                    return GestureDetector(
                      onTap: () => cubit.toggleWatchlist(movieMap),
                      child: Icon(
                        isInList ? Icons.bookmark : Icons.bookmark_border,
                        color: isInList
                            ? Colors.yellow
                            : Colors.white.withValues(alpha: 0.7),
                        size: 18.r,
                      ),
                    );
                  },
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  releaseYear,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _popularMovieTileApi(
    BuildContext context,
    MovieModel movie,
    bool isFavorite,
  ) {
    return GestureDetector(
      onTap: () =>
          context.push(AppRouter.movieDetailsPath(movie.id.toString())),
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
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 85.h,
                width: 65.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 85.h,
                  width: 65.w,
                  color: Colors.grey,
                  child: const Icon(Icons.movie),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    movie.releaseDate,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: kButtonsColor, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.read<HomeCubit>().toggleFavorite(movie.id),
              child: Icon(
                isFavorite ? Icons.bookmark : Icons.bookmark_border,
                color: kButtonsColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';
import 'package:movie_verse_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:movie_verse_app/features/home/presentation/cubits/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is HomeSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.movie,
                                color: kButtonsColor,
                                size: 20.sp,
                              ),
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
                              _iconButton(
                                Icons.search,
                                onTap: () => context.push(AppRouter.kExplore),
                              ),
                              SizedBox(width: 10.w),
                              _iconButton(Icons.notifications_none),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      _buildBanner(context, state.featuredMovie),
                      SizedBox(height: 30.h),
                      _sectionTitle('Categories'),
                      SizedBox(height: 15.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final genre in state.genres)
                              GestureDetector(
                                onTap: () => context
                                    .read<HomeCubit>()
                                    .selectGenre(genre.id),
                                child: _categoryItem(
                                  genre.name,
                                  genre.id == state.selectedGenreId,
                                ),
                              ),
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
                          itemCount: state.trendingMovies.length,
                          separatorBuilder: (_, index) => SizedBox(width: 15.w),
                          itemBuilder: (context, index) => _trendingCardApi(
                            context,
                            state.trendingMovies[index],
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),

                      _sectionTitle('Popular Movies'),
                      SizedBox(height: 18.h),
                      Column(
                        children: state.movies
                            .map(
                              (movie) => Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: _popularMovieTileApi(
                                  context,
                                  movie,
                                  state.favoriteMovieIds.contains(movie.id),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: kSurfaceColor,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, MovieModel? featuredMovie) {
    if (featuredMovie == null) {
      return Container(
        height: 210.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(28.r),
        ),
      );
    }

    final imageProvider = NetworkImage(
      'https://image.tmdb.org/t/p/w500${featuredMovie.backdropPath.isNotEmpty ? featuredMovie.backdropPath : featuredMovie.posterPath}',
    );
    final title = featuredMovie.title;

    return Container(
      height: 210.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
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
                'TRENDING',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => context.push(
                AppRouter.movieDetailsPath(featuredMovie.id.toString()),
              ),
              child: Container(
                width: 155.w,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
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

  Widget _trendingCardApi(BuildContext context, MovieModel movie) {
    final releaseYear = movie.releaseDate.length >= 4
        ? movie.releaseDate.substring(0, 4)
        : movie.releaseDate;
    return GestureDetector(
      onTap: () =>
          context.push(AppRouter.movieDetailsPath(movie.id.toString())),
      child: Container(
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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22.r)),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200.h,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Icon(Icons.movie),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: kButtonsColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      movie.voteAverage.toStringAsFixed(1),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    movie.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    releaseYear,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popularMovieTileApi(
    BuildContext context,
    MovieModel movie,
    bool isFavorite,
  ) {
    return GestureDetector(
      onTap: () =>
          context.push(AppRouter.movieDetailsPath(movie.id.toString())),
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
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 85.h,
                width: 65.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 85.h,
                  width: 65.w,
                  color: Colors.grey,
                  child: const Icon(Icons.movie),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    movie.releaseDate,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: kButtonsColor, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/