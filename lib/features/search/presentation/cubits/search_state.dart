import 'package:movie_verse_app/features/home/data/models/movie_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<String> trendingSearches;
  final List<MovieModel> searchResults;
  final String query;
  final bool isSearching;

  SearchSuccess({
    this.trendingSearches = const [],
    this.searchResults = const [],
    this.query = '',
    this.isSearching = false,
  });
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}
