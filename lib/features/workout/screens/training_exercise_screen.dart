import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/workout/screens/training_set_screen.dart';

import '../models/training_exercise.dart';
import '../providers/workout_providers.dart';

class TrainingExerciseScreen extends ConsumerWidget {
  final String folderId;
  final String folderName;

  const TrainingExerciseScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync =
    ref.watch(exercisesProvider(folderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: exercisesAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error: $err')),
        data: (exercises) =>
            _ExerciseList(exercises: exercises, folderId: folderId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showCreateDialog(context, ref, folderId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context,
      WidgetRef ref,
      String folderId,
      ) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Exercise'),
          content: TextField(
            controller: controller,
            decoration:
            const InputDecoration(labelText: 'Exercise name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                final api =
                ref.read(workoutApiServiceProvider);

                await api.createExercise(folderId, name);

                ref.invalidate(exercisesProvider(folderId));

                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class _ExerciseList extends ConsumerWidget {
  final List<TrainingExercise> exercises;
  final String folderId;

  const _ExerciseList({
    required this.exercises,
    required this.folderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (exercises.isEmpty) {
      return const Center(
        child: Text('No exercises yet.'),
      );
    }

    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];

        return Dismissible(
          key: ValueKey(exercise.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) async {
            final api = ref.read(workoutApiServiceProvider);

            await api.deleteExercise(folderId, exercise.id);

            ref.invalidate(exercisesProvider(folderId));
          },
          child: ListTile(
            title: Text(exercise.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      TrainingSetScreen(
                        exerciseId: exercise.id,
                        exerciseName: exercise.name,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }}