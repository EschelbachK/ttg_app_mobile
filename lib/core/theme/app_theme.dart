import 'package:flutter/material.dart';

class AppTheme {
  // 🍷 Farben
  static const bgDark = Color(0xFF121417);
  static const surfaceDark = Color(0xFF1B1F24);
  static const wine = Color(0xFF7B1E3A);
  static const wineLight = Color(0xFFA23B5A);
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
      centerTitle: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: wine,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        color: textPrimary,
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        color: textSecondary,
      ),
    ),
  );
}