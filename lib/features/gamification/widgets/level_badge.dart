import 'package:flutter/material.dart';

class LevelBadge extends StatelessWidget {
  final int level;

  const LevelBadge({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red),
      ),
      child: Text(
        "LEVEL $level",
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}