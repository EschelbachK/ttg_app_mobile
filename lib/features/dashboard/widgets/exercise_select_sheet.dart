import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/state/exercise_catalog_provider.dart';
import 'exercise_input_dialog.dart';

class ExerciseSelectSheet extends ConsumerWidget {

  final String category;
  final String folderId;
  final String planId;

  const ExerciseSelectSheet({
    super.key,
    required this.category,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final exercisesAsync = ref.watch(exerciseCatalogProvider);

    return Container(

      height: 500,

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),

      child: exercisesAsync.when(

        data: (exercises) {

          final filtered = exercises.where((e) {

            return e["bodyRegion"] == category.toUpperCase();

          }).toList();

          return ListView.builder(

            itemCount: filtered.length,

            itemBuilder: (context, index) {

              final exercise = filtered[index];

              return ListTile(

                title: Text(exercise["name"]),

                subtitle: Text(
                  exercise["equipment"] ?? "",
                ),

                onTap: () {

                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (_) => ExerciseInputDialog(
                      category: category,
                      name: exercise["name"],
                      folderId: folderId,
                      planId: planId,
                    ),
                  );
                },
              );
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text("Fehler: $e"),
        ),
      ),
    );
  }
}