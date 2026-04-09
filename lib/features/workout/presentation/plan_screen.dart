import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ttg_app_mobile/features/workout/providers/workout_provider.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import 'package:ttg_app_mobile/features/workout/presentation/training_plan_card.dart';
import 'package:ttg_app_mobile/features/workout/presentation/widgets/ttg_glass_card.dart';

class PlanScreen extends ConsumerWidget {
  final List<TrainingPlan> availablePlans;

  const PlanScreen({super.key, required this.availablePlans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('PLÄNE')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: availablePlans.length,
          itemBuilder: (context, index) {
            final plan = availablePlans[index];

            return TtgGlassCard(
              child: TrainingPlanCard(
                plan: plan,
                onStart: () async {
                  await controller.startWorkoutFromPlan(plan);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                        context, '/workout/active');
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}