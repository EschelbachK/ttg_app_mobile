import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ai_coach_provider.dart';

class WeightSuggestionChip extends ConsumerWidget {
  const WeightSuggestionChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coach = ref.watch(aiCoachProvider);

    final weight = coach.suggestWeight();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(
        "Suggested: ${weight.toStringAsFixed(1)} kg",
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}