import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise.dart';
import '../state/dashboard_provider.dart';

class ExerciseInputDialog extends ConsumerStatefulWidget {

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
  ConsumerState<ExerciseInputDialog> createState() => _ExerciseInputDialogState();
}

class _ExerciseInputDialogState extends ConsumerState<ExerciseInputDialog> {

  double weight = 0;
  int reps = 0;
  int sets = 0;

  Future<void> pickNumber(
      String title,
      Function(int) onSelected,
      ) async {

    final controller = TextEditingController();

    await showDialog(

      context: context,

      builder: (_) => AlertDialog(

        title: Text(title),

        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),

        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"),
          ),

          ElevatedButton(
            onPressed: () {

              final value = int.tryParse(controller.text) ?? 0;

              onSelected(value);

              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final notifier = ref.read(dashboardProvider.notifier);

    return AlertDialog(

      backgroundColor: const Color(0xFF1B1F23),

      title: Text(
        widget.name,
        style: const TextStyle(color: Colors.white),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              buildField("GEWICHT (KG)", weight as int, (v) {
                setState(() => weight = v as double);
              }),

              buildField("WIEDERHOLUNGEN", reps, (v) {
                setState(() => reps = v);
              }),

              buildField("SÄTZE", sets, (v) {
                setState(() => sets = v);
              }),

            ],
          ),

          const SizedBox(height: 20),
        ],
      ),

      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Abbrechen"),
        ),

        ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3B30),
          ),

          onPressed: () {

            final exercise = Exercise(

              id: DateTime.now().millisecondsSinceEpoch.toString(),

              category: widget.category,
              name: widget.name,

              weight: weight,
              reps: reps,
              sets: sets,
            );

            notifier.addExercise(
              widget.folderId,
              widget.planId,
              exercise,
            );

            Navigator.pop(context);
          },

          child: const Text("hinzufügen"),
        )
      ],
    );
  }

  Widget buildField(
      String title,
      int value,
      Function(int) onSelected,
      ) {

    return GestureDetector(

      onTap: () {
        pickNumber(title, onSelected);
      },

      child: Column(

        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}