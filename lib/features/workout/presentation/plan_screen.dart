import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/workout/presentation/training_plan_card.dart';
import '../domain/workout_training_plan.dart';
import '../providers/workout_provider.dart';

class PlanScreen extends ConsumerWidget {
  final List<TrainingPlan> availablePlans;
  const PlanScreen({super.key, required this.availablePlans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Trainingspläne')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availablePlans.length,
        itemBuilder: (_, index) {
          final plan = availablePlans[index];
          return TrainingPlanCard(
            plan: plan,
            onStart: () async {
              await controller.startWorkoutFromPlan();
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}