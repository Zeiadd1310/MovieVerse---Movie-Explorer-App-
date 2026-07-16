import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesUpdated extends FavoritesState {
  final List<Map<String, dynamic>> favorites;
  final List<Map<String, dynamic>> watchlist;
  FavoritesUpdated({required this.favorites, required this.watchlist});
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  final List<Map<String, dynamic>> _favorites = [];
  final List<Map<String, dynamic>> _watchlist = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);
  List<Map<String, dynamic>> get watchlist => List.unmodifiable(_watchlist);

  bool isFavorite(String id) => _favorites.any((e) => e['id'] == id);
  bool isInWatchlist(String id) => _watchlist.any((e) => e['id'] == id);

  void _emit() => emit(
    FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
    ),
  );

  void toggleFavorite(Map<String, dynamic> item) {
    final i = _favorites.indexWhere((e) => e['id'] == item['id']);
    if (i != -1) {
      _favorites.removeAt(i);
    } else {
      _favorites.add(item);
    }
    _emit();
  }

  void toggleWatchlist(Map<String, dynamic> item) {
    final i = _watchlist.indexWhere((e) => e['id'] == item['id']);
    if (i != -1) {
      _watchlist.removeAt(i);
    } else {
      _watchlist.add(item);
    }
    _emit();
  }

  void removeFavoriteById(String id) {
    _favorites.removeWhere((e) => e['id'] == id);
    _emit();
  }

  void removeWatchlistById(String id) {
    _watchlist.removeWhere((e) => e['id'] == id);
    _emit();
  }
}
