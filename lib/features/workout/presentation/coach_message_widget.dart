import 'package:flutter/material.dart';
import '../application/workout_controller.dart';
import '../domain/workout_session.dart';

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
    final suggestion = controller.getSuggestion(exercise);
    if (suggestion == null) return const SizedBox();

    final reason = suggestion.reason.toLowerCase();

    final color = reason.contains('increase')
        ? Colors.green
        : reason.contains('plateau')
        ? Colors.orange
        : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        suggestion.reason,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}