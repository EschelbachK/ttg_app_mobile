import 'package:flutter/material.dart';

class AppTheme {
  static const primaryRed = Color(0xFFE10600);

  static const primaryButtonGradient = LinearGradient(
    colors: [Color(0xFFFF1A1A), Color(0xFFE10600)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const background = Color(0xFF000000);
  static const card = Color(0xFF1A1F26);

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: background,
    primaryColor: primaryRed,
  );
}