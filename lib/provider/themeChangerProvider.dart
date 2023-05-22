import 'package:flutter/material.dart';

class ThemeChangerProvider extends ChangeNotifier {
  bool _isDarkTheme = false;

  get isDarkTheme => _isDarkTheme;

  setIsDarkTheme(isDarkTheme) {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }
}