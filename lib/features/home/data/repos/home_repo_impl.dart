import 'package:movie_verse_app/core/utils/functions/api_service.dart';
import 'package:movie_verse_app/features/home/data/models/genre_model.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';
import 'package:movie_verse_app/features/home/data/repos/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final ApiService apiService;

  HomeRepoImpl(this.apiService);

  @override
  Future<List<MovieModel>> getPopularMovies({int? genreId}) async {
    final endPoint = genreId != null ? 'discover/movie' : 'movie/popular';
    final query = genreId != null
        ? {
            'with_genres': genreId,
            'sort_by': 'popularity.desc',
          }
        : null;

    final data = await apiService.get(
      endPoint: endPoint,
      query: query,
    );

    final List movies = data['results'] ?? [];

    return movies
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final data = await apiService.get(endPoint: 'genre/movie/list');
    final List genres = data['genres'] ?? [];
    return genres
        .map((genre) => GenreModel.fromJson(genre))
        .toList();
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final data = await apiService.get(endPoint: 'trending/movie/week');
    final List movies = data['results'] ?? [];
    return movies
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  }
}
