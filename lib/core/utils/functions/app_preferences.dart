import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferences {
  static const _hasLaunchedBeforeKey = 'has_launched_before';

  static Future<bool> hasLaunchedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasLaunchedBeforeKey) ?? false;
  }

  static Future<void> markLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasLaunchedBeforeKey, true);
  }
}
