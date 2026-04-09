import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/layout/app_layout.dart';
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
        child: Center(child: Text('No active workout')),
      );
    }

    final exercise = session.groups
        .expand((g) => g.exercises)
        .firstWhere(
          (e) => e.id == exerciseId,
      orElse: () =>
      const ExerciseSession(id: '', name: '', order: 0, sets: []),
    );

    if (exercise.id.isEmpty) {
      return const AppLayout(
        title: 'Sets',
        child: Center(child: Text('Exercise not found')),
      );
    }

    if (exercise.sets.isEmpty) {
      return const AppLayout(
        title: 'Sets',
        child: Center(child: Text('Keine Sets')),
      );
    }

    return AppLayout(
      title: exercise.name,
      child: ListView.builder(
        itemCount: exercise.sets.length,
        itemBuilder: (_, index) {
          final set = exercise.sets[index];

          return ListTile(
            title: Text('${set.reps} reps • ${set.weight} kg'),
          );
        },
      ),
    );
  }
}