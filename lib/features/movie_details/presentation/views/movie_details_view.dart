import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/core/utils/functions/api_service.dart';
import 'package:movie_verse_app/features/favourites/presentation/cubits/favorites_cubit.dart';
import 'package:movie_verse_app/core/utils/functions/app_router.dart';
import 'package:movie_verse_app/features/movie_details/data/models/movie_details_model.dart';
import 'package:movie_verse_app/features/movie_details/data/repos/movie_details_repo_imp.dart';
import 'package:movie_verse_app/features/movie_details/data/repos/review_repo_impl.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/movie_details_cubit.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/movie_details_state.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/review_cubit.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/review_state.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieIdParam = GoRouterState.of(context).pathParameters['movieId'];
    final movieId = int.tryParse(movieIdParam ?? '') ?? 0;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: favoritesCubit),
        BlocProvider(
          create: (context) {
            final cubit = MovieDetailsCubit(MovieDetailsRepoImpl(apiService: ApiService()));
            cubit.getMovieDetails(movieId: movieId);
            // تحديث حالة الإشارة المرجعية عند تحميل البيانات
            WidgetsBinding.instance.addPostFrameCallback((_) {
              favoritesCubit.loadData();
            });
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = ReviewCubit(
              ReviewRepoImpl(firestore: FirebaseFirestore.instance),
            );
            if (userId != null) {
              cubit.getReview(userId: userId, movieId: movieId);
            }
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: kDetailsBackground,
        body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading || state is MovieDetailsInitial) {
              return const Center(
                child: CircularProgressIndicator(color: kButtonsColor),
              );
            }
            if (state is MovieDetailsError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    state.errMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              );
            }

            final successState = state as MovieDetailsSuccess;
            final movie = successState.movieDetailsModel;
            final isFavorite = successState.isFavorite;
            final isBookmarked = successState.isBookmarked;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, movie, isBookmarked),
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
                                Icon(
                                  Icons.star,
                                  color: kButtonsColor,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '${movie.formattedRating} • ${movie.releaseYear} • ${movie.formattedRuntime}',
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
                            SizedBox(height: 35.h),
                            _buildYourReviewSection(context, movieId),
                            SizedBox(height: 140.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFloatingReviewButton(context, movieIdParam ?? '', movie),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    MovieDetailsModel movie,
    bool isBookmarked,
  ) {
    return Stack(
      children: [
        Image.network(
          movie.fullBackdropUrl,
          height: 500.h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(height: 500.h, color: Colors.black),
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
                  // HEART / FAVORITE ICON
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFav = favoritesCubit.isFavorite(movie.id.toString());
                      final movieMap = {
                        'id': movie.id.toString(),
                        'title': movie.title,
                        'subtitle': movie.releaseDate ?? '',
                        'rating': movie.voteAverage.toStringAsFixed(1),
                        'image': 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      };
                      return _circleIcon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        onTap: () => favoritesCubit.toggleFavorite(movieMap),
                      );
                    },
                  ),
                  SizedBox(width: 15.w),
                  // BOOKMARK ICON (Share icon has been completely removed)
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final cubit = context.read<FavoritesCubit>();
                      final movieMap = {
                        'id': movie.id.toString(),
                        'title': movie.title,
                        'subtitle': movie.releaseDate ?? '',
                        'rating': movie.voteAverage.toStringAsFixed(1),
                        'image': 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      };
                      final isInWatchlist = cubit.isInWatchlist(movie.id.toString());
                      return _circleIcon(
                        isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                        onTap: () => cubit.toggleWatchlist(movieMap),
                      );
                    },
                  ),
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
              for (int i = 0; i < movie.genres.length; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                _genreChip(movie.genres[i].name, isYellow: i == 0),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYourReviewSection(BuildContext context, int movieId) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is! ReviewSuccess || state.review == null) {
          return const SizedBox.shrink();
        }

        final review = state.review!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Your Review'),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < review.rating.round()
                              ? Icons.star
                              : Icons.star_outline,
                          color: kButtonsColor,
                          size: 20.sp,
                        );
                      }),
                      SizedBox(width: 8.w),
                      Text(
                        review.rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                          color: kButtonsColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (review.review.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Text(
                      review.review,
                      style: GoogleFonts.inter(
                        color: kSlateText,
                        fontSize: 14.sp,
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCastSection(MovieDetailsModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "See All" completely removed
        _sectionTitle('Top Cast'),
        SizedBox(height: 20.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [for (final member in movie.topCast) _castAvatar(member)],
          ),
        ),
      ],
    );
  }
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
          backgroundImage: member.profilePath != null
              ? NetworkImage(member.fullProfileUrl)
              : null,
          child: member.profilePath == null
              ? Icon(Icons.person, color: Colors.white38, size: 32.sp)
              : null,
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
          parts.length > 1 ? parts.last : '',
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

Widget _buildFloatingReviewButton(
  BuildContext context,
  String movieId,
  MovieDetailsModel movie,
) {
  return Positioned(
    bottom: 30.h,
    left: 20.w,
    right: 20.w,
    child: BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        final hasReview = state is ReviewSuccess && state.review != null;

        return GestureDetector(
          onTap: () async {
            await context.push(
              AppRouter.reviewRatingPath(movieId),
              extra: movie,
            );
            final userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null && context.mounted) {
              context.read<ReviewCubit>().getReview(
                userId: userId,
                movieId: movie.id,
              );
            }
          },
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
                Icon(
                  hasReview ? Icons.edit_outlined : Icons.rate_review_outlined,
                  color: Colors.black,
                  size: 28.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  hasReview ? 'Edit Review' : 'Add Review',
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
        );
      },
    ),
  );
}
