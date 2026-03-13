import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise.dart';
import '../state/dashboard_provider.dart';
import 'exercise_select_sheet.dart';

class ExerciseSelectionCard extends ConsumerStatefulWidget {

  final String folderId;
  final String planId;

  const ExerciseSelectionCard({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  ConsumerState<ExerciseSelectionCard> createState() =>
      _ExerciseSelectionCardState();
}

class _ExerciseSelectionCardState
    extends ConsumerState<ExerciseSelectionCard> {

  String? selectedCategory;
  String? selectedExercise;

  double weight = 0;
  int reps = 0;
  int sets = 0;

  final List<String> categories = [

    "Brustmuskulatur",
    "Rücken",
    "Beine",
    "Schultern",
    "Bizeps",
    "Trizeps",
    "Bauchmuskulatur",
    "Nacken",
    "Unterarme",
    "Cardio",
    "Ganzkörpertraining",
  ];

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 20),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1B1F23),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// CATEGORY
          const Text(
            "KATEGORIE",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          GestureDetector(

            onTap: () {

              showModalBottomSheet(

                context: context,
                backgroundColor: const Color(0xFF1B1F23),

                builder: (_) {

                  return ListView.builder(

                    itemCount: categories.length,

                    itemBuilder: (context, index) {

                      final category = categories[index];

                      return ListTile(

                        title: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),

                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.white38,
                        ),

                        onTap: () {

                          setState(() {

                            selectedCategory = category;
                            selectedExercise = null;

                          });

                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              );
            },

            child: Text(

              selectedCategory ?? "Hier tippen",

              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),

          const Divider(color: Colors.white12, height: 30),

          /// EXERCISE
          const Text(
            "ÜBUNG",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          GestureDetector(

            onTap: () async {

              if (selectedCategory == null) {

                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(
                    content: Text("Bitte zuerst eine Kategorie auswählen"),
                  ),
                );

                return;
              }

              final result = await showModalBottomSheet<String>(

                context: context,
                backgroundColor: Colors.transparent,

                builder: (_) => ExerciseSelectSheet(
                  category: selectedCategory!,
                ),
              );

              if (result != null) {

                setState(() {
                  selectedExercise = result;
                });

              }
            },

            child: Text(

              selectedExercise ?? "Hier tippen",

              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),

          const Divider(color: Colors.white12, height: 30),

          /// INPUT ROW
          Row(

            children: [

              Expanded(
                child: buildField(
                  "GEWICHT (KG)",
                  weight.toStringAsFixed(1),
                ),
              ),

              Expanded(
                child: buildField(
                  "WIEDERHOLUNGEN",
                  reps.toString(),
                ),
              ),

              Expanded(
                child: buildField(
                  "SÄTZE",
                  sets.toString(),
                ),
              ),

            ],
          ),

          const SizedBox(height: 20),

          /// ADD BUTTON
          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
              ),

              onPressed: () {

                if (selectedExercise == null ||
                    selectedCategory == null) return;

                final exercise = Exercise(

                  id: DateTime.now().millisecondsSinceEpoch.toString(),

                  category: selectedCategory!,
                  name: selectedExercise!,

                  weight: weight,
                  reps: reps,
                  sets: sets,
                );

                ref.read(dashboardProvider.notifier).addExercise(

                  widget.folderId,
                  widget.planId,
                  exercise,

                );

                /// SUCCESS POPUP
                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(
                    content: Text("Übung erfolgreich hinzugefügt"),
                    duration: Duration(seconds: 2),
                  ),

                );

                /// RESET
                setState(() {

                  selectedCategory = null;
                  selectedExercise = null;

                  weight = 0;
                  reps = 0;
                  sets = 0;

                });

              },

              child: const Text(
                "hinzufügen",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String title, String value) {

    return Column(

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
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}