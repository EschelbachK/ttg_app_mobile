import 'package:flutter/material.dart';

class AppTheme {

  static const Color primaryRed = Color(0xFFE10600);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [
      Color(0xFFFF1A1A),
      Color(0xFFE10600),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color background = Color(0xFF000000);
  static const Color card = Color(0xFF1A1F26);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: background,
    primaryColor: primaryRed,
  );
}