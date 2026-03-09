import 'package:flutter/material.dart';

class AppTheme {
  static const bgDark = Colors.black;
  static const surfaceDark = Color(0xFF12141A);
  static const wine = Color(0xFF7B1E3A);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0B3B8);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    colorScheme: const ColorScheme.dark(
      primary: wine,
      surface: surfaceDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bgDark,
      elevation: 0,
    ),
  );
}