import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/workout_session.dart';
import '../../providers/workout_provider.dart';
import 'set_row.dart';
import 'ttg_glass_card.dart';
import 'add_set_button.dart';
import 'rest_timer_widget.dart';

class ExerciseBlock extends ConsumerWidget {
  final ExerciseSession exercise;

  const ExerciseBlock({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutProvider.notifier);
    final suggestion = controller.getSuggestion(exercise);

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
              if (suggestion != null)
                Text(
                  suggestion.reason,
                  style: const TextStyle(fontSize: 12),
                ),
              AddSetButton(
                exerciseId: exercise.id,
                suggestedWeight: suggestion?.suggestedWeight,
                suggestedReps: suggestion?.suggestedReps,
              ),
            ],
          ),
        ),
      ),
    );
  }
}