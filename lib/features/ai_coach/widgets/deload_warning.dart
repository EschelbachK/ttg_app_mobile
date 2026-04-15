import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ai_coach_provider.dart';

class DeloadWarning extends ConsumerWidget {
  const DeloadWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coach = ref.watch(aiCoachProvider);

    if (!coach.shouldDeload()) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red),
      ),
      child: const Text(
        "🧠 Deload recommended — your CNS is fatigued",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}