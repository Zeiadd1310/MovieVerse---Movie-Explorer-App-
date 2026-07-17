import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_verse_app/core/data/providers.dart';
import 'package:movie_verse_app/core/services/notification_service.dart';

/// Holds the three notification toggles and keeps them in sync with
/// Firestore (`users/{uid}`) and the scheduled local notifications.
class NotificationPrefs {
  bool newReleases = true;
  bool recommendations = true;
  bool watchlistReminders = false;

  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      newReleases = data['notifNewReleases'] ?? newReleases;
      recommendations = data['notifRecommendations'] ?? recommendations;
      watchlistReminders =
          data['notifWatchlistReminders'] ?? watchlistReminders;
    }
    _loaded = true;

    if (recommendations) {
      await NotificationService.instance.scheduleWeeklyRecommendation();
    }
  }

  Future<void> _persist() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'notifNewReleases': newReleases,
      'notifRecommendations': recommendations,
      'notifWatchlistReminders': watchlistReminders,
    }, SetOptions(merge: true));
  }

  Future<void> setNewReleases(bool value) async {
    newReleases = value;
    await _persist();
    for (final item in favoritesCubit.watchlist) {
      final id = item['id'].toString();
      if (value) {
        await NotificationService.instance.scheduleNewRelease(
          movieId: id,
          title: item['title'] ?? '',
          releaseDate: DateTime.tryParse(item['releaseDate'] ?? ''),
        );
      } else {
        await NotificationService.instance.cancelRelease(id);
      }
    }
  }

  Future<void> setRecommendations(bool value) async {
    recommendations = value;
    await _persist();
    if (value) {
      await NotificationService.instance.scheduleWeeklyRecommendation();
    } else {
      await NotificationService.instance.cancelRecommendation();
    }
  }

  Future<void> setWatchlistReminders(bool value) async {
    watchlistReminders = value;
    await _persist();
    for (final item in favoritesCubit.watchlist) {
      final id = item['id'].toString();
      if (value) {
        await NotificationService.instance.scheduleWatchlistReminder(
          movieId: id,
          title: item['title'] ?? '',
        );
      } else {
        await NotificationService.instance.cancelReminder(id);
      }
    }
  }
}

final notificationPrefs = NotificationPrefs();
