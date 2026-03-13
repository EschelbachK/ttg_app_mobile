import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'exercise_select_sheet.dart';
import 'exercise_input_dialog.dart';

class ExerciseSelectionCard extends ConsumerStatefulWidget {

  final String folderId;
  final String planId;

  const ExerciseSelectionCard({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  ConsumerState<ExerciseSelectionCard> createState() => _ExerciseSelectionCardState();
}

class _ExerciseSelectionCardState extends ConsumerState<ExerciseSelectionCard> {

  String? selectedCategory;
  String? selectedExercise;

  int weight = 0;
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

                      return InkWell(

                        splashColor: const Color(0xFFFF3B30).withOpacity(0.25),
                        highlightColor: const Color(0xFFFF3B30).withOpacity(0.15),

                        onTap: () {

                          setState(() {

                            selectedCategory = category;
                            selectedExercise = null;

                          });

                          Navigator.pop(context);
                        },

                        child: ListTile(

                          title: Text(
                            category,
                            style: const TextStyle(color: Colors.white),
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
                child: Center(
                  child: buildField("GEWICHT (KG)", weight, () {
                    pickNumber("Gewicht", (v) => setState(() => weight = v));
                  }),
                ),
              ),
              Expanded(
                child: Center(
                  child: buildField("WIEDERHOLUNGEN", reps, () {
                    pickNumber("Wiederholungen", (v) => setState(() => reps = v));
                  }),
                ),
              ),
              Expanded(
                child: Center(
                  child: buildField("SÄTZE", sets, () {
                    pickNumber("Sätze", (v) => setState(() => sets = v));
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
                foregroundColor: Colors.white,
              ),

              onPressed: () {

                if (selectedExercise == null) return;

                showDialog(

                  context: context,

                  builder: (_) => ExerciseInputDialog(
                    category: selectedCategory!,
                    name: selectedExercise!,
                    folderId: widget.folderId,
                    planId: widget.planId,
                  ),
                );
              },

              child: const Text(
                "hinzufügen",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String title, int value, VoidCallback onTap) {

    return GestureDetector(

      onTap: onTap,

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

  Future<void> pickNumber(String title, Function(int) onSelected) async {

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
          )
        ],
      ),
    );
  }
}