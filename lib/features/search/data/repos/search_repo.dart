import 'package:movie_verse_app/features/home/data/models/movie_model.dart';

abstract class SearchRepo {
  Future<List<MovieModel>> searchMovies(String query);
  Future<List<String>> getTrendingSearches();
}
