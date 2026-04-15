import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ai_coach_provider.dart';

class AICoachBanner extends ConsumerWidget {
  const AICoachBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coach = ref.watch(aiCoachProvider);

    final message = coach.coachMessage();
    final fatigue = coach.fatigueScore();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: fatigue > 70 ? Colors.red : Colors.green,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Fatigue: ${fatigue.toStringAsFixed(1)}%",
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}