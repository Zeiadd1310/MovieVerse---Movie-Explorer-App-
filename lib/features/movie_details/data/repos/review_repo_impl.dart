import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/features/movie_details/data/models/review_model.dart';
import 'package:movie_verse_app/features/movie_details/data/repos/review_repo.dart';

class ReviewRepoImpl implements ReviewRepo {
  final FirebaseFirestore firestore;

  ReviewRepoImpl({required this.firestore});

  @override
  Future<Either<Failure, void>> submitReview({
    required String userId,
    required ReviewModel review,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('reviews')
          .doc(review.movieId.toString())
          .set(review.toMap());

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewModel?>> getReview({
    required String userId,
    required int movieId,
  }) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('reviews')
          .doc(movieId.toString())
          .get();

      if (!doc.exists) {
        return const Right(null);
      }

      return Right(ReviewModel.fromMap(doc.data()!));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview({
    required String userId,
    required int movieId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('reviews')
          .doc(movieId.toString())
          .delete();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}