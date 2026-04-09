import 'package:flutter/material.dart';
import '../../domain/workout_session.dart';
import 'set_row.dart';
import 'ttg_glass_card.dart';
import 'add_set_button.dart';
import 'rest_timer_widget.dart';

class ExerciseBlock extends StatelessWidget {
  final ExerciseSession exercise;

  const ExerciseBlock({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final lastSet = exercise.sets.isNotEmpty ? exercise.sets.last : null;

    final suggestedWeight =
    lastSet != null ? lastSet.weight + 2.5 : null;
    final suggestedReps = lastSet?.reps;

    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(exercise.name),
            ...exercise.sets.asMap().entries.map(
                  (e) => Column(
                children: [
                  SetRow(
                    index: e.key,
                    weight: e.value.weight,
                    reps: e.value.reps,
                  ),
                  if (e.key == exercise.sets.length - 1)
                    const RestTimerWidget(seconds: 60),
                ],
              ),
            ),
            AddSetButton(
              exerciseId: exercise.id,
              suggestedWeight: suggestedWeight,
              suggestedReps: suggestedReps,
            ),
          ],
        ),
      ),
    );
  }
}