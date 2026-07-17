import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper around flutter_local_notifications used to drive the three
/// notification-settings toggles (new releases, recommendations, watchlist
/// reminders). All notifications are scheduled on-device.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'movieverse_reminders';
  static const _channelName = 'MovieVerse Reminders';
  static const int _recommendationId = 900000;

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'New releases, recommendations and watchlist reminders',
    );
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(channel);
    await androidImpl?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  int _reminderId(String movieId) => ('reminder_$movieId').hashCode & 0x7fffffff;
  int _releaseId(String movieId) => ('release_$movieId').hashCode & 0x7fffffff;

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, _channelName),
        iOS: DarwinNotificationDetails(),
      );

  /// "Remind me to watch saved movies" - fires a few days after a movie is
  /// added to the watchlist.
  Future<void> scheduleWatchlistReminder({
    required String movieId,
    required String title,
  }) async {
    final when = tz.TZDateTime.now(tz.local).add(const Duration(days: 3));
    await _plugin.zonedSchedule(
      id: _reminderId(movieId),
      title: 'Still on your watchlist',
      body: '"$title" is waiting for you. Ready to watch it?',
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// "When movies you follow are available" - fires on a watchlisted movie's
  /// release date, if that date is still in the future.
  Future<void> scheduleNewRelease({
    required String movieId,
    required String title,
    required DateTime? releaseDate,
  }) async {
    if (releaseDate == null || !releaseDate.isAfter(DateTime.now())) return;
    final when = tz.TZDateTime(
      tz.local,
      releaseDate.year,
      releaseDate.month,
      releaseDate.day,
      9,
    );
    await _plugin.zonedSchedule(
      id: _releaseId(movieId),
      title: 'Now available',
      body: '"$title" from your watchlist just released!',
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(String movieId) =>
      _plugin.cancel(id: _reminderId(movieId));

  Future<void> cancelRelease(String movieId) =>
      _plugin.cancel(id: _releaseId(movieId));

  /// Cancels both notification types for a movie, e.g. when it's removed
  /// from the watchlist entirely.
  Future<void> cancelForMovie(String movieId) async {
    await cancelReminder(movieId);
    await cancelRelease(movieId);
  }

  /// "Movies we think you'll love" - a recurring weekly nudge while enabled.
  Future<void> scheduleWeeklyRecommendation() async {
    final when = tz.TZDateTime.now(tz.local).add(const Duration(days: 7));
    await _plugin.zonedSchedule(
      id: _recommendationId,
      title: 'New recommendations',
      body: "We've picked new movies we think you'll love. Check them out!",
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelRecommendation() =>
      _plugin.cancel(id: _recommendationId);
}
