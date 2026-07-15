import 'package:dartz/dartz.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/features/movie_details/data/models/review_model.dart';

abstract class ReviewRepo {
  Future<Either<Failure, void>> submitReview({
    required String userId,
    required ReviewModel review,
  });

  Future<Either<Failure, ReviewModel?>> getReview({
    required String userId,
    required int movieId,
  });

  Future<Either<Failure, void>> deleteReview({
    required String userId,
    required int movieId,
  });
}