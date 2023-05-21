import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[300],
      appBarTheme:
          AppBarTheme(backgroundColor: Colors.grey[300], centerTitle: true),
      canvasColor: Colors.black,
      colorScheme: ColorScheme.fromSwatch().copyWith(background: Colors.black),
      tabBarTheme: TabBarTheme(
        indicatorColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        overlayColor: MaterialStateProperty.all(Colors.grey[400]),
        dividerColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.black, centerTitle: true),
      canvasColor: Colors.grey[800],
      cardColor: Colors.grey[900],
      tabBarTheme: TabBarTheme(
        indicatorColor: Colors.grey,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.white,
        overlayColor: MaterialStateProperty.all(Colors.grey[900]),
        dividerColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[900],
        filled: true,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
    );
  }
}
