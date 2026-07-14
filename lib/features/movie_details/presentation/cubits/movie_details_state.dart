import 'package:movie_verse_app/features/movie_details/data/models/movie_details_model.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetailsModel movieDetailsModel;

  MovieDetailsSuccess(this.movieDetailsModel);
}

class MovieDetailsError extends MovieDetailsState {
  final String errMessage;

  MovieDetailsError(this.errMessage);
}