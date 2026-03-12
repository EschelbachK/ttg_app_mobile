import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise_tile.dart';
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

    final notifier = ref.read(dashboardProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F12),

      appBar: AppBar(
        title: Text(plan.name),
        backgroundColor: const Color(0xFF0E0F12),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: plan.exercises.length,
              itemBuilder: (context, index) {

                final exercise = plan.exercises[index];

                return ExerciseTile(exercise: exercise);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(

              icon: const Icon(Icons.add),

              label: const Text("Übung hinzufügen"),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
              ),

              onPressed: () {

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ExerciseCatalog(
                    folderId: folderId,
                    planId: plan.id,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}