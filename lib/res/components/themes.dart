import 'package:flutter/material.dart';

class CustomTheme{
  static ThemeData get lightTheme{
    return ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true
    );
  }

  static ThemeData get darkTheme{
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,


    );
  }
}