import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/exercise_catalog_provider.dart';
import '../models/exercise_catalog_item.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_folder.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise.dart';

class ExerciseCatalogScreen extends ConsumerWidget {
  const ExerciseCatalogScreen({super.key});

  String buildImageUrl(String path) {
    if (path.isEmpty) return "";
    return "http://10.0.2.2:8080$path";
  }

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

              final imageUrl = buildImageUrl(exercise.imageUrl);

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                child: ListTile(

                  leading: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
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

                  subtitle: Text(
                    "${exercise.bodyRegion} • ${exercise.equipment}",
                  ),

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