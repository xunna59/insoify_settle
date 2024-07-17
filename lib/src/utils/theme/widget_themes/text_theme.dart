import 'package:flutter/material.dart';

class XTextTheme {
  // Light Mode Text theme
  static TextTheme lightTextTheme = const TextTheme(
    headlineMedium: TextStyle(
      color: Colors.black87,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
    ),
  );

  // Dark Mode Text Theme
  static TextTheme darkTextTheme = const TextTheme(
    headlineMedium: TextStyle(
      color: Colors.white,
    ),
    displaySmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(
      color: Colors.white,
    ),
  );
}
