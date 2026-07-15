import 'package:movie_verse_app/features/movie_details/data/models/movie_details_model.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetailsModel movieDetailsModel;
  final bool isFavorite;
  final bool isBookmarked;

  MovieDetailsSuccess(
    this.movieDetailsModel, {
    this.isFavorite = false,
    this.isBookmarked = false,
  });

  MovieDetailsSuccess copyWith({
    MovieDetailsModel? movieDetailsModel,
    bool? isFavorite,
    bool? isBookmarked,
  }) {
    return MovieDetailsSuccess(
      movieDetailsModel ?? this.movieDetailsModel,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class MovieDetailsError extends MovieDetailsState {
  final String errMessage;

  MovieDetailsError(this.errMessage);
}