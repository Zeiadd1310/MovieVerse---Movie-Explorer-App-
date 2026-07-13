import 'package:movie_verse_app/features/home/data/models/genre_model.dart';
import 'package:movie_verse_app/features/home/data/models/movie_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<MovieModel> movies;
  final List<GenreModel> genres;
  final List<MovieModel> trendingMovies;
  final MovieModel? featuredMovie;
  final int? selectedGenreId;
  final List<int> favoriteMovieIds;

  HomeSuccess({
    required this.movies,
    required this.genres,
    required this.trendingMovies,
    required this.featuredMovie,
    this.selectedGenreId,
    this.favoriteMovieIds = const [],
  });
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}