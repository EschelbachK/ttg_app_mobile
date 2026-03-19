import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../catalog/state/exercise_catalog_provider.dart';
import '../../../catalog/models/exercise_catalog_item.dart';

class ExerciseSelectSheet extends ConsumerWidget {

  final String category;

  const ExerciseSelectSheet({
    super.key,
    required this.category,
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

    return Container(

      height: 500,

      decoration: const BoxDecoration(
        color: Color(0xFF1B1F23),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),

      child: exercisesAsync.when(

        data: (List<ExerciseCatalogItem> exercises) {

          final filtered = exercises
              .where((e) => e.bodyRegion == mappedCategory)
              .toList();

          return ListView.builder(

            itemCount: filtered.length,

            itemBuilder: (context, index) {

              final exercise = filtered[index];

              return ListTile(

                title: Text(
                  exercise.name,
                  style: const TextStyle(color: Colors.white),
                ),

                subtitle: Text(
                  exercise.equipment,
                  style: const TextStyle(color: Colors.white54),
                ),

                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                ),

                onTap: () {

                  Navigator.pop(context, exercise.name);

                },
              );
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(
            "Fehler: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}