import 'package:movie_verse_app/features/movie_details/data/models/review_model.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final ReviewModel? review;

  ReviewSuccess(this.review);
}

class ReviewSubmitted extends ReviewState {}

class ReviewDeleted extends ReviewState {}

class ReviewError extends ReviewState {
  final String errMessage;

  ReviewError(this.errMessage);
}