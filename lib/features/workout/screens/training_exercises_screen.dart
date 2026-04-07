import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';
import '../providers/workout_providers.dart';

class TrainingExercisesScreen extends ConsumerWidget {
  final String folderId;
  final String planId;

  const TrainingExercisesScreen({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider(folderId));

    return AppLayout(
      title: 'Übungen',
      child: exercisesAsync.when(
        data: (exercises) {
          if (exercises.isEmpty) {
            return const Center(child: Text('Keine Übungen'));
          }

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];

              return ListTile(
                title: Text(exercise.name),
                onTap: () => context.go(
                  '/workout/exercises/${exercise.id}/sets',
                ),
              );
            },
          );
        },
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }
}