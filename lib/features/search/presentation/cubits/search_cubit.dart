import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/search/data/repos/search_repo.dart';
import 'package:movie_verse_app/features/search/presentation/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  final List<String> _trendingSearches = [];
  String _currentQuery = '';
  Timer? _debounceTimer;

  SearchCubit(this.searchRepo) : super(SearchInitial());

  Future<void> loadSearchData() async {
    emit(SearchLoading());
    try {
      final chips = await searchRepo.getTrendingSearches();
      _trendingSearches.clear();
      _trendingSearches.addAll(chips);
      emit(SearchSuccess(
        trendingSearches: _trendingSearches,
        searchResults: const [],
        query: '',
        isSearching: false,
      ));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  void searchMovies(String query) {
    _currentQuery = query.trim();
    _debounceTimer?.cancel();

    if (_currentQuery.isEmpty) {
      emit(SearchSuccess(
        trendingSearches: List<String>.from(_trendingSearches),
        searchResults: const [],
        query: '',
        isSearching: false,
      ));
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _executeSearch(_currentQuery);
    });
  }

  Future<void> _executeSearch(String query) async {
    final searchQuery = query.trim();
    emit(SearchSuccess(
      trendingSearches: List<String>.from(_trendingSearches),
      searchResults: const [],
      query: searchQuery,
      isSearching: true,
    ));

    try {
      final results = await searchRepo.searchMovies(searchQuery);
      if (searchQuery != _currentQuery) return;
      emit(SearchSuccess(
        trendingSearches: List<String>.from(_trendingSearches),
        searchResults: results,
        query: searchQuery,
        isSearching: false,
      ));
    } catch (e) {
      if (searchQuery != _currentQuery) return;
      emit(SearchFailure(e.toString()));
    }
  }

  Future<void> retry() async {
    if (_currentQuery.isEmpty) {
      await loadSearchData();
    } else {
      await _executeSearch(_currentQuery);
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
