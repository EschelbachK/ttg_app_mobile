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

  static ThemeData _base(ColorScheme scheme, Color bg) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    primaryColor: primaryRed,
    progressIndicatorTheme:
    const ProgressIndicatorThemeData(color: primaryRed),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: scheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      selectionColor: scheme.brightness == Brightness.dark
          ? Colors.white30
          : Colors.black26,
      selectionHandleColor: scheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    ),
  );

  static final darkTheme = _base(
    const ColorScheme.dark(
      primary: primaryRed,
      secondary: primaryRed,
      surface: backgroundDark,
    ),
    backgroundDark,
  );

  static final lightTheme = _base(
    const ColorScheme.light(
      primary: primaryRed,
      secondary: primaryRed,
      surface: backgroundLight,
    ),
    backgroundLight,
  );
}