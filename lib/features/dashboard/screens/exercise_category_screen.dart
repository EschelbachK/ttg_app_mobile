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

  String mapCategoryToBodyRegion(String category) {

    switch (category.toLowerCase()) {

      case "brustmuskulatur":
        return "BRUST";

      case "rücken":
        return "RUECKEN";

      case "beine":
        return "BEINE";

      case "schulter":
      case "schultern":
        return "SCHULTERN";

      case "bizeps":
        return "BIZEPS";

      case "trizeps":
        return "TRIZEPS";

      case "bauchmuskulatur":
        return "BAUCH";

      case "nacken":
        return "NACKEN";

      case "unterarme":
        return "UNTERARME";

      case "cardio":
        return "CARDIO";

      case "ganzkörpertraining":
        return "GANZKOERPER";

      default:
        return category.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final exercisesAsync = ref.watch(exerciseCatalogProvider);

    final mappedCategory = mapCategoryToBodyRegion(category);

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

          final filteredExercises = exercises
              .where((exercise) => exercise.bodyRegion == mappedCategory)
              .toList();

          if (filteredExercises.isEmpty) {
            return const Center(
              child: Text(
                "Keine Übungen gefunden",
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(

            itemCount: filteredExercises.length,

            itemBuilder: (context, index) {

              final exercise = filteredExercises[index];

              return Container(

                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFF1B1F23),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: ListTile(

                  title: Text(
                    exercise.name,
                    style: const TextStyle(color: Colors.white),
                  ),

                  subtitle: Text(
                    "${exercise.primaryMuscle} • ${exercise.equipment}",
                    style: const TextStyle(color: Colors.white54),
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white38,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}