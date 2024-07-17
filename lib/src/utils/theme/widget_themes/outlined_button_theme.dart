import 'package:flutter/material.dart';

class XOutlinedButtonTheme {
  // for light mode
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 175, 173, 173),
      side: const BorderSide(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // for dark mode
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 175, 173, 173),
      side: const BorderSide(color: Colors.white), // Border color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Button border radius
      ),
    ),
  );
}
