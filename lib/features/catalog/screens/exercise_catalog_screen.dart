import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/exercise_catalog_provider.dart';
import '../models/exercise_catalog_item.dart';

class ExerciseCatalogScreen extends ConsumerWidget {
  const ExerciseCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final exercisesAsync = ref.watch(exerciseCatalogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
      ),

      body: exercisesAsync.when(

        data: (List<ExerciseCatalogItem> exercises) {

          if (exercises.isEmpty) {
            return const Center(
              child: Text("No exercises found"),
            );
          }

          return ListView.builder(
            itemCount: exercises.length,

            itemBuilder: (context, index) {

              final exercise = exercises[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                child: ListTile(

                  leading: exercise.imageUrl.isNotEmpty
                      ? Image.network(
                    exercise.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.fitness_center),

                  title: Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(exercise.id),

                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Selected: ${exercise.name}"),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },

        loading: () =>
        const Center(child: CircularProgressIndicator()),

        error: (error, stack) =>
            Center(child: Text(error.toString())),
      ),
    );
  }
}