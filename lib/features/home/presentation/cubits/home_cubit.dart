import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/home/data/repos/home_repo.dart';
import 'package:movie_verse_app/features/home/presentation/cubits/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> loadHomeData({int? genreId}) async {
    final currentFavorites = state is HomeSuccess
        ? (state as HomeSuccess).favoriteMovieIds
        : const <int>[];

    emit(HomeLoading());

    try {
      final genres = await homeRepo.getGenres();
      final trendingMovies = await homeRepo.getTrendingMovies();
      final selectedGenreId = genreId ?? (genres.isNotEmpty ? genres.first.id : null);
      final movies = await homeRepo.getPopularMovies(genreId: selectedGenreId);

      final featuredMovie = movies.isNotEmpty ? movies.first : null;

      emit(HomeSuccess(
        movies: movies,
        genres: genres,
        trendingMovies: trendingMovies,
        featuredMovie: featuredMovie,
        selectedGenreId: selectedGenreId,
        favoriteMovieIds: currentFavorites,
      ));
    } catch (e) {
      print("========== API ERROR ==========");
      print(e.toString());

      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> getPopularMovies() => loadHomeData();

  void selectGenre(int genreId) {
    if (state is HomeSuccess) {
      loadHomeData(genreId: genreId);
    }
  }

  void toggleFavorite(int movieId) {
    if (state is HomeSuccess) {
      final currentState = state as HomeSuccess;
      final currentFavorites = List<int>.from(currentState.favoriteMovieIds);

      if (currentFavorites.contains(movieId)) {
        currentFavorites.remove(movieId);
      } else {
        currentFavorites.add(movieId);
      }

      emit(HomeSuccess(
        movies: currentState.movies,
        genres: currentState.genres,
        trendingMovies: currentState.trendingMovies,
        featuredMovie: currentState.featuredMovie,
        selectedGenreId: currentState.selectedGenreId,
        favoriteMovieIds: currentFavorites,
      ));
    }
  }
}