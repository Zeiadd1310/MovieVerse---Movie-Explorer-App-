import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesUpdated extends FavoritesState {
  final List<Map<String, dynamic>> favorites;
  final List<Map<String, dynamic>> watchlist;
  final List<Map<String, dynamic>> watched;
  FavoritesUpdated({
    required this.favorites,
    required this.watchlist,
    required this.watched,
  });
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _favRef =>
      _db.collection('users').doc(_uid).collection('favorites');

  CollectionReference get _watchRef =>
      _db.collection('users').doc(_uid).collection('watchlist');

  CollectionReference get _watchedRef =>
      _db.collection('users').doc(_uid).collection('watched');

  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _watchlist = [];
  List<Map<String, dynamic>> _watched = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);
  List<Map<String, dynamic>> get watchlist => List.unmodifiable(_watchlist);
  List<Map<String, dynamic>> get watched => List.unmodifiable(_watched);

  bool isFavorite(String id) => _favorites.any((e) => e['id'] == id);
  bool isInWatchlist(String id) => _watchlist.any((e) => e['id'] == id);
  bool isWatched(String id) => _watched.any((e) => e['id'] == id);

  Future<void> loadData() async {
    // Skip if already loaded to prevent unnecessary reloads
    if (state is! FavoritesInitial) return;
    
    emit(FavoritesLoading());

    final favSnap = await _favRef.get();
    _favorites = favSnap.docs
        .map((d) => {...d.data() as Map<String, dynamic>, 'id': d.id})
        .toList();

    final watchSnap = await _watchRef.get();
    _watchlist = watchSnap.docs
        .map((d) => {...d.data() as Map<String, dynamic>, 'id': d.id})
        .toList();

    final watchedSnap = await _watchedRef.get();
    _watched = watchedSnap.docs
        .map((d) => {...d.data() as Map<String, dynamic>, 'id': d.id})
        .toList();

    emit(FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
      watched: List.from(_watched),
    ));
  }

  Future<void> toggleFavorite(Map<String, dynamic> item) async {
    final docId = item['id'].toString();
    final docRef = _favRef.doc(docId);
    final exists = (await docRef.get()).exists;

    if (exists) {
      _favorites.removeWhere((e) => e['id'] == docId);
      emit(FavoritesUpdated(
        favorites: List.from(_favorites),
        watchlist: List.from(_watchlist),
        watched: List.from(_watched),
      )); // UI updates instantly
      await docRef.delete(); // Firestore update happens after
    } else {
      _favorites.add({...item, 'id': docId});
      emit(FavoritesUpdated(
        favorites: List.from(_favorites),
        watchlist: List.from(_watchlist),
        watched: List.from(_watched),
      )); // UI updates instantly
      await docRef.set({
        'title': item['title'],
        'subtitle': item['subtitle'],
        'rating': item['rating'],
        'image': item['image'],
      }); // Firestore update happens after
    }
  }

  Future<void> toggleWatchlist(Map<String, dynamic> item) async {
    final docId = item['id'].toString();
    final docRef = _watchRef.doc(docId);
    final exists = (await docRef.get()).exists;

    if (exists) {
      _watchlist.removeWhere((e) => e['id'] == docId);
      emit(FavoritesUpdated(
        favorites: List.from(_favorites),
        watchlist: List.from(_watchlist),
        watched: List.from(_watched),
      )); // UI updates instantly
      await docRef.delete(); // Firestore update happens after
    } else {
      _watchlist.add({...item, 'id': docId});
      emit(FavoritesUpdated(
        favorites: List.from(_favorites),
        watchlist: List.from(_watchlist),
        watched: List.from(_watched),
      )); // UI updates instantly
      await docRef.set({
        'title': item['title'],
        'subtitle': item['subtitle'],
        'rating': item['rating'],
        'image': item['image'],
      }); // Firestore update happens after
    }
  }

  Future<void> removeFavoriteById(String id) async {
    _favorites.removeWhere((e) => e['id'] == id);
    emit(FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
      watched: List.from(_watched),
    )); // UI updates instantly
    await _favRef.doc(id).delete(); // Firestore update happens after
  }

  Future<void> removeWatchlistById(String id) async {
    _watchlist.removeWhere((e) => e['id'] == id);
    emit(FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
      watched: List.from(_watched),
    )); // UI updates instantly
    await _watchRef.doc(id).delete(); // Firestore update happens after
  }

  Future<void> addToWatched(Map<String, dynamic> item) async {
    final docId = item['id'].toString();

    _watchlist.removeWhere((e) => e['id'] == docId);
    _watched.removeWhere((e) => e['id'] == docId);
    _watched.add({...item, 'id': docId});

    emit(FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
      watched: List.from(_watched),
    ));

    final watchDoc = await _watchRef.doc(docId).get();
    if (watchDoc.exists) {
      await _watchRef.doc(docId).delete();
    }

    await _watchedRef.doc(docId).set({
      'title': item['title'],
      'subtitle': item['subtitle'],
      'rating': item['rating'],
      'image': item['image'],
    });
  }

  Future<void> moveToWatched(Map<String, dynamic> item) async {
    final docId = item['id'].toString();
    
    // Remove from watchlist (optimistic)
    _watchlist.removeWhere((e) => e['id'] == docId);
    
    // Add to watched (optimistic)
    _watched.add({...item, 'id': docId});
    
    emit(FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
      watched: List.from(_watched),
    )); // UI updates instantly
    
    // Firestore updates happen after (non-blocking for UI)
    await _watchRef.doc(docId).delete();
    await _watchedRef.doc(docId).set({
      'title': item['title'],
      'subtitle': item['subtitle'],
      'rating': item['rating'],
      'image': item['image'],
    });
  }

  Future<void> removeWatchedById(String id) async {
    _watched.removeWhere((e) => e['id'] == id);
    emit(FavoritesUpdated(
      favorites: List.from(_favorites),
      watchlist: List.from(_watchlist),
      watched: List.from(_watched),
    )); // UI updates instantly
    await _watchedRef.doc(id).delete(); // Firestore update happens after
  }
}
