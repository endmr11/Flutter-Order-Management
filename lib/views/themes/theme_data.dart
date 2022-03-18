import 'package:flutter/material.dart';

class ThemeCustomData {
  static final ThemeCustomData _instance = ThemeCustomData._internal();
  factory ThemeCustomData() => _instance;
  ThemeCustomData._internal();

  static final lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );
  static final darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );
}
