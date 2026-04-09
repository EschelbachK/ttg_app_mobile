import 'package:flutter/material.dart';
import '../../domain/workout_session.dart';
import 'set_row.dart';
import 'ttg_glass_card.dart';

class ExerciseBlock extends StatelessWidget {
  final ExerciseSession exercise;

  const ExerciseBlock({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(exercise.name),
            ...exercise.sets.asMap().entries.map(
                  (e) => SetRow(
                index: e.key,
                weight: e.value.weight,
                reps: e.value.reps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}