import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/core/utils/functions/api_service.dart';
import 'package:movie_verse_app/features/movie_details/data/models/movie_details_model.dart';
import 'package:movie_verse_app/features/movie_details/data/repos/movie_details_repo.dart';

class MovieDetailsRepoImpl implements MovieDetailsRepo {
  final ApiService apiService;

  MovieDetailsRepoImpl({required this.apiService});

  @override
  Future<Either<Failure, MovieDetailsModel>> getMovieDetails({
    required int movieId,
  }) async {
    try {
      final response = await apiService.get(
        endPoint: 'movie/$movieId',
        query: {'append_to_response': 'credits'},
      );
      final movieDetailsModel = MovieDetailsModel.fromJson(response);
      return Right(movieDetailsModel);
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}