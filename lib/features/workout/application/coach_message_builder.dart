import 'package:flutter/material.dart';

import '../application/workout_controller.dart';
import '../domain/workout_session.dart';
import '../domain/progression_result.dart';

class CoachMessageWidget extends StatelessWidget {
  final ExerciseSession exercise;
  final WorkoutController controller;

  const CoachMessageWidget({
    super.key,
    required this.exercise,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ProgressionResult? suggestion =
    controller.getSuggestion(exercise);

    if (suggestion == null) return const SizedBox();

    final reason = suggestion.reason;

    final color = reason.contains('Increase')
        ? Colors.green
        : reason.contains('plateau')
        ? Colors.orange
        : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        reason,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}