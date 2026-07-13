import 'package:movie_verse_app/features/home/data/models/genre_model.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';

abstract class HomeRepo {
  Future<List<MovieModel>> getPopularMovies({int? genreId});
  Future<List<GenreModel>> getGenres();
  Future<List<MovieModel>> getTrendingMovies();
}