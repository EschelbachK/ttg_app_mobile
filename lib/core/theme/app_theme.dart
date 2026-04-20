import 'package:flutter/material.dart';

class AppTheme {
  static const primaryRed = Color(0xFFE10600);

  static const primaryButtonGradient = LinearGradient(
    colors: [Color(0xFFFF1A1A), Color(0xFFE10600)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundDark = Color(0xFF000000);
  static const backgroundLight = Color(0xFFF5F6F8);

  static ThemeData _base(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    primaryColor: primaryRed,
    progressIndicatorTheme:
    const ProgressIndicatorThemeData(color: primaryRed),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: scheme.onBackground,
      selectionColor: scheme.onBackground.withOpacity(0.2),
      selectionHandleColor: scheme.onBackground,
    ),
  );

  static final darkTheme = _base(
    const ColorScheme.dark(
      primary: primaryRed,
      secondary: primaryRed,
      background: backgroundDark,
      surface: Color(0xFF0A0A0A),
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
  );

  static final lightTheme = _base(
    const ColorScheme.light(
      primary: primaryRed,
      secondary: primaryRed,
      background: backgroundLight,
      surface: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
  );
}