import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise_selection_card.dart';
import '../widgets/exercise_catalog.dart';

class MuscleGroupScreen extends ConsumerWidget {

  final String folderId;
  final TrainingPlan plan;

  const MuscleGroupScreen({
    super.key,
    required this.folderId,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final dashboardState = ref.watch(dashboardProvider);

    TrainingPlan currentPlan = plan;

    /// aktuelles Plan Objekt aus Provider holen
    for (final folder in dashboardState.folders) {

      if (folder.id == folderId) {

        for (final p in folder.plans) {

          if (p.id == plan.id) {
            currentPlan = p;
          }

        }

      }

    }

    final hasExercises = currentPlan.exercises.isNotEmpty;

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
          currentPlan.name,
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
                currentPlan.name.toUpperCase(),
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

          /// Roter Button (nur wenn noch keine Übungen existieren)
          if (!hasExercises)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(

                borderRadius: BorderRadius.circular(16),

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseCatalog(
                        folderId: folderId,
                        planId: currentPlan.id,
                      ),
                    ),
                  );

                },

                child: Container(

                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(

                    color: const Color(0xFFFF3B30),

                    borderRadius: BorderRadius.circular(16),

                  ),

                  child: const Column(

                    children: [

                      Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                        size: 32,
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

                      SizedBox(height: 4),

                      Text(
                        "Tippe hier um den Übungskatalog zu öffnen",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          /// Exercise hinzufügen (bleibt immer aktiv)
          ExerciseSelectionCard(
            folderId: folderId,
            planId: currentPlan.id,
          ),

          const SizedBox(height: 20),

          /// Liste der Übungen
          Expanded(

            child: currentPlan.exercises.isEmpty

                ? const Center(
              child: Text(
                "Noch keine Übungen hinzugefügt",
                style: TextStyle(color: Colors.white38),
              ),
            )

                : ListView.builder(

              itemCount: currentPlan.exercises.length,

              itemBuilder: (context, index) {

                final exercise = currentPlan.exercises[index];

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