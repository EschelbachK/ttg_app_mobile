import 'package:flutter/material.dart';
import '../../application/motivation_engine.dart';

class StreakWidget extends StatelessWidget {
  final MotivationEngine motivator;

  const StreakWidget({super.key, required this.motivator});

  @override
  Widget build(BuildContext context) {
    return Text(
      '🔥 ${motivator.streak.streakCount} Tage',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}