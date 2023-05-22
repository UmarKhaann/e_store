import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeData{

  static Future<bool> getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkTheme') ?? false;
  }
  static Future<void> setThemePreference(bool isDarkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
  }
}