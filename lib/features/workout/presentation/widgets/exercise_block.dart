import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/workout_session.dart';
import '../../providers/workout_provider.dart';
import 'set_row.dart';
import 'add_set_button.dart';

const kPrimaryRed = Color(0xFFE10600);

class ExerciseBlock extends ConsumerWidget {
  final ExerciseSession exercise;

  const ExerciseBlock({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutProvider.notifier);
    final suggestion = controller.getSuggestion(exercise);

    final sets = exercise.sets;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 16, height: 2, color: kPrimaryRed),
              const SizedBox(width: 6),
              Text(
                exercise.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(width: 16, height: 2, color: kPrimaryRed),
            ],
          ),

          const SizedBox(height: 12),

          if (sets.isNotEmpty)
            ...sets.asMap().entries.map((entry) {
              final set = entry.value;
              if (set == null) return const SizedBox();

              return SetRow(
                index: entry.key,
                exerciseId: exercise.id,
                setId: set.id,
                weight: set.weight,
                reps: set.reps,
                completed: set.completed,
              );
            }),

          const SizedBox(height: 2),

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