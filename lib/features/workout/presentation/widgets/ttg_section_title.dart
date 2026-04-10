import 'package:flutter/material.dart';

class TtgSectionTitle extends StatelessWidget {
  final String title;

  const TtgSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.white,
      ),
    );
  }
}