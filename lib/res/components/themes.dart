import 'package:flutter/material.dart';

class CustomTheme{
  static ThemeData get lightTheme{
    return ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[400],
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey[400], centerTitle: true),
      cardTheme: CardTheme(color: Colors.grey[200]),
    );
  }

  static ThemeData get darkTheme{
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,


    );
  }
}