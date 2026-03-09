import 'package:flutter/material.dart';

class AppTheme {
  static const bg = Color(0xFF1E2428);
  static const card = Color(0xFF2A3136);
  static const cardSoft = Color(0xFF30383E);
  static const accent = Color(0xFF1DA1F2);
  static const text = Colors.white;
  static const textDim = Colors.white70;

  static ThemeData? get darkTheme => null;

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bg,
      cardColor: card,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: text),
      ),
    );
  }
}