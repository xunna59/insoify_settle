// locale_manager.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static SharedPreferences? _prefs;
  static const String _localeKey = 'app_locale';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getLocale() {
    return _prefs?.getString(_localeKey) ?? 'en';
  }

  static Future<void> setLocale(String locale) async {
    await _prefs?.setString(_localeKey, locale);
  }
}
