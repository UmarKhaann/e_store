import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[300],
      appBarTheme:
          AppBarTheme(backgroundColor: Colors.grey[300], centerTitle: true),
      progressIndicatorTheme: ProgressIndicatorThemeData(
          refreshBackgroundColor: Colors.white,
          color: Colors.black,
          circularTrackColor: Colors.grey[300]),
      brightness: Brightness.light,
      canvasColor: Colors.black,
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
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.black, centerTitle: true),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          refreshBackgroundColor: Colors.black,
          circularTrackColor: Colors.black,
          color: Colors.white),
      brightness: Brightness.dark,
      indicatorColor: Colors.white,
      canvasColor: Colors.grey[800],
      cardColor: Colors.grey[900],
      tabBarTheme: TabBarTheme(
          indicatorColor: Colors.grey,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          overlayColor: MaterialStateProperty.all(Colors.grey[900]),
          dividerColor: Colors.transparent),
      iconTheme: const IconThemeData(color: Colors.white),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white))),
      sliderTheme: SliderThemeData(
        trackHeight: 2,
        thumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.black,
        disabledInactiveTrackColor: Colors.black,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
    );
  }
}
