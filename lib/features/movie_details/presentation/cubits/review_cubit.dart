import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/movie_details/data/models/review_model.dart';
import 'package:movie_verse_app/features/movie_details/data/repos/review_repo.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepo reviewRepo;

  ReviewCubit(this.reviewRepo) : super(ReviewInitial());

  Future<void> submitReview({
    required String userId,
    required ReviewModel review,
  }) async {
    emit(ReviewLoading());

    final result = await reviewRepo.submitReview(
      userId: userId,
      review: review,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.errMessage)),
      (_) => emit(ReviewSubmitted()),
    );
  }

  Future<void> getReview({
    required String userId,
    required int movieId,
  }) async {
    emit(ReviewLoading());

    final result = await reviewRepo.getReview(
      userId: userId,
      movieId: movieId,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.errMessage)),
      (review) => emit(ReviewSuccess(review)),
    );
  }

  Future<void> deleteReview({
    required String userId,
    required int movieId,
  }) async {
    emit(ReviewLoading());

    final result = await reviewRepo.deleteReview(
      userId: userId,
      movieId: movieId,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.errMessage)),
      (_) => emit(ReviewDeleted()),
    );
  }
}