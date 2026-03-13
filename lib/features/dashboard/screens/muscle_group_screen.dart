import 'package:flutter/material.dart';
import '../models/training_plan.dart';
import '../widgets/exercise_selection_card.dart';

class MuscleGroupScreen extends StatelessWidget {

  final String folderId;
  final TrainingPlan plan;

  const MuscleGroupScreen({
    super.key,
    required this.folderId,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0B0D10),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFF3B30),
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          plan.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Column(

        children: [

          const SizedBox(height: 20),

          Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Text(
                plan.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.edit,
                color: Colors.white54,
                size: 18,
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// NEW SELECTION CARD
          ExerciseSelectionCard(
            folderId: folderId,
            planId: plan.id,
          ),

          const SizedBox(height: 20),

          Expanded(

            child: plan.exercises.isEmpty

                ? const Center(
              child: Text(
                "Noch keine Übungen hinzugefügt",
                style: TextStyle(color: Colors.white38),
              ),
            )

                : ListView.builder(

              itemCount: plan.exercises.length,

              itemBuilder: (context, index) {

                final exercise = plan.exercises[index];

                return Container(

                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),

                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1F23),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),

                      const Icon(
                        Icons.more_vert,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}