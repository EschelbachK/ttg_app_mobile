import 'package:flutter/material.dart';
import '../models/training_plan.dart';
import '../widgets/exercise_catalog.dart';

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
          icon: const Icon(Icons.arrow_back),
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

          /// ADD EXERCISE CARD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: GestureDetector(

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseCatalog(
                      folderId: folderId,
                      planId: plan.id,
                    ),
                  ),
                );
              },

              child: Container(

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: const [

                    Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 30,
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Füge Übungen hinzu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Tippe hier um den Übungskatalog zu öffnen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

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

      floatingActionButton: FloatingActionButton(

        backgroundColor: const Color(0xFFFF3B30),

        child: const Icon(Icons.add),

        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseCatalog(
                folderId: folderId,
                planId: plan.id,
              ),
            ),
          );
        },
      ),
    );
  }
}