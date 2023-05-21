import 'package:flutter/material.dart';

class ThemeChangerProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkTheme = false;

  get themeMode => _themeMode;
  get isDarkTheme => _isDarkTheme;

  setThemeMode(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  setIsDarkTheme(isDarkTheme) {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }
}