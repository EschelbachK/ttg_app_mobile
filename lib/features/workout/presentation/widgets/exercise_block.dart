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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      child: TtgGlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              ...exercise.sets.asMap().entries.map(
                    (e) {
                  final isLast = e.key == exercise.sets.length - 1;

                  return Column(
                    children: [
                      SetRow(
                        index: e.key,
                        weight: e.value.weight,
                        reps: e.value.reps,
                      ),
                      if (isLast && exercise.sets.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: RestTimerWidget(seconds: 60),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              AddSetButton(
                exerciseId: exercise.id,
                suggestedWeight: suggestedWeight,
                suggestedReps: suggestedReps,
              ),
            ],
          ),
        ),
      ),
    );
  }
}