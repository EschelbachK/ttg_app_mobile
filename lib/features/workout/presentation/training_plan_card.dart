import 'package:flutter/material.dart';
import '../domain/workout_training_plan.dart';

class TrainingPlanCard extends StatelessWidget {
  final TrainingPlan plan;
  final VoidCallback onStart;
  const TrainingPlanCard({super.key, required this.plan, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(plan.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...plan.exercises.map((e) => Text('${e.name}: ${e.reps}x @ ${e.weight}kg')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onStart, child: const Text('Start')),
        ]),
      ),
    );
  }
}