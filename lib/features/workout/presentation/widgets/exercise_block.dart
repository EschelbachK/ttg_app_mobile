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

    return TtgGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          ...exercise.sets.asMap().entries.map((e) {
            final set = e.value;
            final isLast = e.key == exercise.sets.length - 1;

            return Column(
              children: [
                SetRow(
                  index: e.key,
                  exerciseId: exercise.id,
                  setId: set.id,
                  weight: set.weight,
                  reps: set.reps,
                  completed: set.completed,
                ),
                if (isLast && set.completed)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: RestTimerWidget(seconds: 60),
                  ),
              ],
            );
          }),

          const SizedBox(height: 12),

          AddSetButton(
            exerciseId: exercise.id,
            suggestedWeight: suggestion?.weight,
            suggestedReps: suggestion?.reps,
          ),
        ],
      ),
    );
  }
}