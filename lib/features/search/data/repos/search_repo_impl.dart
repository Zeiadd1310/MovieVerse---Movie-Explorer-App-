import 'package:movie_verse_app/core/utils/functions/api_service.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';
import 'package:movie_verse_app/features/search/data/repos/search_repo.dart';

class SearchRepoImpl extends SearchRepo {
  final ApiService apiService;

  SearchRepoImpl(this.apiService);

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final data = await apiService.get(
      endPoint: 'search/movie',
      query: {
        'query': query,
      },
    );

    final List movies = data['results'] ?? [];
    return movies
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  }

  @override
  Future<List<String>> getTrendingSearches() async {
    final data = await apiService.get(endPoint: 'movie/popular');
    final List movies = data['results'] ?? [];

    return movies
        .map((movie) => MovieModel.fromJson(movie))
        .where((movie) => movie.title.isNotEmpty)
        .take(8)
        .map((movie) => movie.title)
        .toList();
  }
}
