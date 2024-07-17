import 'package:flutter/material.dart';
import 'widget_themes/date_picker_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_theme.dart';

class XAppTheme {
  XAppTheme._();
  static const Color appPrimaryColor = Colors.white;
  static const Color appSecondaryColor = Colors.black;
  static const Color appTertiaryColor = Color.fromARGB(255, 175, 173, 173);
  static const Color dashPrimaryColor = Color.fromARGB(255, 29, 29, 29);

  //Light Mode Theme Data
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Calibri',
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: appPrimaryColor,
      secondary: appSecondaryColor,
      tertiary: appTertiaryColor,
      primaryContainer: dashPrimaryColor,
    ),
    textTheme: XTextTheme.lightTextTheme,
    elevatedButtonTheme: XElevetatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: XOutlinedButtonTheme.lightOutlinedButtonTheme,
    datePickerTheme: XDatePickerTheme.lightDatePickerTheme,
  );
// Dark Mode Theme Data
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Calibri',
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: appSecondaryColor,
      secondary: appPrimaryColor,
      tertiary: appTertiaryColor,
      primaryContainer: dashPrimaryColor,
    ),
    textTheme: XTextTheme.darkTextTheme,
    elevatedButtonTheme: XElevetatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: XOutlinedButtonTheme.darkOutlinedButtonTheme,
    datePickerTheme: XDatePickerTheme.darkDatePickerTheme,
  );
}
