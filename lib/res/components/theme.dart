import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.white,
        progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.black, circularTrackColor: Colors.grey[300]),
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.grey[300], centerTitle: true),
        canvasColor: Colors.black,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(background: Colors.black),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          overlayColor: MaterialStateProperty.all(Colors.grey[400]),
          dividerColor: Colors.transparent,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 2,
          thumbColor: Colors.black,
          activeTrackColor: Colors.black,
          inactiveTrackColor: Colors.grey,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.white,
        secondaryHeaderColor: Colors.black,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        brightness: Brightness.dark,
        useMaterial3: true,
        indicatorColor: Colors.white,
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
        iconTheme: const IconThemeData(color: Colors.white),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 2,
          thumbColor: Colors.grey[400],
          inactiveTrackColor: Colors.black,
          disabledInactiveTrackColor: Colors.black,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[900],
        ));
  }
}
