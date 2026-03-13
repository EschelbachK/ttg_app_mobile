import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/models/exercise_catalog_item.dart';
import '../../catalog/state/exercise_catalog_provider.dart';

class ExerciseCategoryScreen extends ConsumerWidget {

  final String category;
  final String folderId;
  final String planId;

  const ExerciseCategoryScreen({
    super.key,
    required this.category,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final exercisesAsync = ref.watch(exerciseCatalogProvider);

    return Scaffold(

      backgroundColor: const Color(0xFF0B0D10),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,
        title: Text(
          category,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: exercisesAsync.when(

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ),

        data: (List<ExerciseCatalogItem> exercises) {

          return ListView.builder(

            itemCount: exercises.length,

            itemBuilder: (context, index) {

              final exercise = exercises[index];

              return ListTile(

                title: Text(
                  exercise.name,
                  style: const TextStyle(color: Colors.white),
                ),

              );
            },
          );
        },
      ),
    );
  }
}