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

    final controller = ref.read(workoutProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TtgSectionTitle(title: 'START WORKOUT'),

              const SizedBox(height: 20),

              TtgPrimaryButton(
                text: 'Quick Start',
                onTap: () async {
                  await controller.startWorkout();
                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorkoutActiveScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              const TtgSectionTitle(title: 'PLÄNE'),

              const SizedBox(height: 12),

              Expanded(
                child: plans.isEmpty
                    ? const Center(
                  child: Text(
                    'Keine Trainingspläne vorhanden',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
                    : ListView.separated(
                  itemCount: plans.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final p = plans[index];

                    return TrainingPlanCard(
                      plan: p,
                      onStart: () async {
                        await controller.startWorkoutFromPlan(p);
                        if (!context.mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const WorkoutActiveScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}