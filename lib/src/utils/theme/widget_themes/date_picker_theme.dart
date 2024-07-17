import 'package:flutter/material.dart';

class XDatePickerTheme {
  // for light mode
  static const lightDatePickerTheme = DatePickerThemeData(
    backgroundColor: Colors.white,
    headerBackgroundColor: Colors.white,
    headerForegroundColor: Colors.black,
    // dayForegroundColor: Colors.blue
  );

  // for dark mode
  static const darkDatePickerTheme = DatePickerThemeData(
    backgroundColor: Colors.black,
    headerBackgroundColor: Colors.black,
    headerForegroundColor: Colors.white,
  );
}
