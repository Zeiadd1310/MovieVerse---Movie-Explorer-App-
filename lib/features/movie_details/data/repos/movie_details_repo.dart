import 'package:dartz/dartz.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/features/movie_details/data/models/movie_details_model.dart';

abstract class MovieDetailsRepo {
  Future<Either<Failure, MovieDetailsModel>> getMovieDetails({
    required int movieId,
  });
}