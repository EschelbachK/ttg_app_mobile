import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/state/dashboard_provider.dart';
import '../../providers/workout_provider.dart';
import '../widgets/ttg_primary_button.dart';
import '../widgets/ttg_section_title.dart';
import '../training_plan_card.dart';
import 'workout_active_screen.dart';

class WorkoutStartScreen extends ConsumerWidget {
  const WorkoutStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final plans = dashboardState.trainingPlans;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const TtgSectionTitle(title: 'START WORKOUT'),
              const SizedBox(height: 20),
              TtgPrimaryButton(
                text: 'Quick Start',
                onTap: () async {
                  await ref.read(workoutProvider.notifier).startWorkout();
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorkoutActiveScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: TtgSectionTitle(title: 'PLÄNE'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: plans.map((p) {
                    return TrainingPlanCard(
                      plan: p,
                      onStart: () async {
                        await ref
                            .read(workoutProvider.notifier)
                            .startWorkoutFromPlan(p);

                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WorkoutActiveScreen(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}