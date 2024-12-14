import 'package:aurora_student/utils/appLanguages.dart';
import 'package:aurora_student/utils/hiveBoxKeys.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  Future<void> setCurrentLanguageCode(String value) async {
    Hive.box(settingsBoxKey).put(currentLanguageCodeKey, value);
  }

  Future<void> setAllowNotification(bool value) async {
    Hive.box(settingsBoxKey).put(allowNotificationKey, value);
  }

  String getCurrentLanguageCode() {
    return Hive.box(settingsBoxKey).get(currentLanguageCodeKey) ??
        defaultLanguageCode;
  }

  bool getAllowNotification() {
    return Hive.box(settingsBoxKey).get(allowNotificationKey) ?? true;
  }

  Future<void> setNotificationCount(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    await prefs.setInt(notificationCountKey, value);
  }

  Future<int> getNotificationCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getInt(notificationCountKey) ?? 0;
  }
}
