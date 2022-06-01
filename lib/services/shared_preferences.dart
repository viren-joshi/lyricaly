import 'package:shared_preferences/shared_preferences.dart';

const String savedListKey = 'SavedList';

class SharedPrefManager {
  static void addTrackToSavedList(Map<String, String> track) {}

  static Future<void> setSavedList(String? json) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(savedListKey)) {
      sharedPreferences.setString(savedListKey, json ?? '');
    } else {
      sharedPreferences.setString(savedListKey, '');
    }
  }

  static Future<String> getSavedList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(savedListKey) ?? '';
  }
}
