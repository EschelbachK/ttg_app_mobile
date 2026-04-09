import 'package:flutter/material.dart';
import '../../application/motivation_engine.dart';

class StreakWidget extends StatelessWidget {
  final MotivationEngine motivator;
  const StreakWidget({super.key, required this.motivator});

  @override
  Widget build(BuildContext context) {
    return Text('🔥 Streak: ${motivator.streak.streakCount} days', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}