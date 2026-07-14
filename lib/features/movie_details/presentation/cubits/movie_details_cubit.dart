import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/movie_details/data/repos/movie_details_repo.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final MovieDetailsRepo movieDetailsRepo;

  MovieDetailsCubit(this.movieDetailsRepo) : super(MovieDetailsInitial());

  Future<void> getMovieDetails({required int movieId}) async {
    emit(MovieDetailsLoading());
    final result = await movieDetailsRepo.getMovieDetails(movieId: movieId);
    result.fold(
      (failure) => emit(MovieDetailsError(failure.errMessage)),
      (movieDetailsModel) => emit(MovieDetailsSuccess(movieDetailsModel)),
    );
  }
}