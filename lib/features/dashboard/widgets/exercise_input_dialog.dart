import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise.dart';
import '../state/dashboard_provider.dart';

class ExerciseInputDialog extends ConsumerWidget {

  final String category;
  final String name;

  final String folderId;
  final String planId;

  const ExerciseInputDialog({
    super.key,
    required this.category,
    required this.name,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final notifier = ref.read(dashboardProvider.notifier);

    final weightController = TextEditingController();
    final repsController = TextEditingController();
    final setsController = TextEditingController();

    return AlertDialog(

      title: Text(name),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: weightController,
            decoration: const InputDecoration(
              labelText: "Gewicht (kg)",
            ),
          ),

          TextField(
            controller: repsController,
            decoration: const InputDecoration(
              labelText: "Wiederholungen",
            ),
          ),

          TextField(
            controller: setsController,
            decoration: const InputDecoration(
              labelText: "Sätze",
            ),
          ),

        ],
      ),

      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Abbrechen"),
        ),

        ElevatedButton(

          onPressed: () {

            final exercise = Exercise(

              id: DateTime.now().millisecondsSinceEpoch.toString(),

              category: category,
              name: name,

              weight: int.tryParse(weightController.text) ?? 0,
              reps: int.tryParse(repsController.text) ?? 0,
              sets: int.tryParse(setsController.text) ?? 0,
            );

            notifier.addExercise(
              folderId,
              planId,
              exercise,
            );

            Navigator.pop(context);
          },

          child: const Text("hinzufügen"),
        )

      ],
    );
  }
}