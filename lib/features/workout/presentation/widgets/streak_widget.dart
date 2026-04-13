import 'package:flutter/material.dart';
import '../../application/motivation_engine.dart';

class StreakWidget extends StatelessWidget {
  final MotivationEngine motivator;

  const StreakWidget({super.key, required this.motivator});

  @override
  Widget build(BuildContext context) {
    final count = motivator.streak.streakCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '🔥 $count Tage',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}