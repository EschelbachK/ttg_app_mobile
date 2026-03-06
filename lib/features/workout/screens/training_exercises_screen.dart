import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_exercise.dart';
import '../models/training_folder.dart';
import '../providers/workout_providers.dart';
import 'training_set_screen.dart';
import '../../catalog/screens/exercise_catalog_screen.dart';

class TrainingExercisesScreen extends ConsumerWidget {
  final TrainingFolder folder;

  const TrainingExercisesScreen({
    super.key,
    required this.folder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync =
    ref.watch(exercisesProvider(folder.id));

    return Scaffold(
      appBar: AppBar(title: Text(folder.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCatalog(context),
        child: const Icon(Icons.add),
      ),
      body: exercisesAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Error: $err')),
        data: (exercises) =>
            _ExerciseList(exercises: exercises, folderId: folder.id),
      ),
    );
  }

  void _openCatalog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ExerciseCatalogScreen(folderId: folder.id),
      ),
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
        child: Text("Keine Übungen vorhanden"),
      );
    }

    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final ex = exercises[index];

        return ListTile(
          title: Text(ex.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TrainingSetScreen(
                  exerciseId: ex.id,
                  exerciseName: ex.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}