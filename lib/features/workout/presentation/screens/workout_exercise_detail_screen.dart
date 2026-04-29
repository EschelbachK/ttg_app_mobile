import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/layout/app_layout_widget.dart';
import '../../providers/workout_provider.dart';
import '../../domain/workout_session.dart';

class WorkoutExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const WorkoutExerciseDetailScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    final session = state.session;

    if (state.isLoading) {
      return const AppLayout(
        title: 'Sets',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (session == null) {
      return const AppLayout(
        title: 'Sets',
        child: Center(child: Text('Kein aktives Workout')),
      );
    }

    final exercise = session.groups
        .expand((g) => g.exercises)
        .where((e) => e.id == exerciseId)
        .cast<ExerciseSession?>()
        .firstWhere((e) => e != null, orElse: () => null);

    if (exercise == null) {
      return const AppLayout(
        title: 'Sets',
        child: Center(child: Text('Übung nicht gefunden')),
      );
    }

    if (exercise.sets.isEmpty) {
      return const AppLayout(
        title: 'Sets',
        child: Center(child: Text('Keine Sets vorhanden')),
      );
    }

    return AppLayout(
      title: exercise.name,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercise.sets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final set = exercise.sets[index];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Satz ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${set.reps} × ${set.weight} kg',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}