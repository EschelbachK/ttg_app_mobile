import 'package:flutter/material.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import 'package:ttg_app_mobile/features/workout/presentation/widgets/ttg_glass_card.dart';

class TrainingPlanCard extends StatelessWidget {
  final TrainingPlan plan;
  final VoidCallback onStart;

  const TrainingPlanCard({
    super.key,
    required this.plan,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onStart,
        child: TtgGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.fitness_center, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      plan.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.play_arrow, color: Colors.green),
                ],
              ),
              const SizedBox(height: 10),

              if (plan.folders != null && plan.folders.isNotEmpty)
                ...plan.folders.map((day) {
                  final groups = day['groups'] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (day['name'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 4),
                          child: Text(
                            day['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ...groups.map((g) {
                        final exercises = g['exercises'] ?? [];

                        return Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g['name'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              ...exercises.map<Widget>((e) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8, top: 2),
                                  child: Text(
                                    "- ${e['name']}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                })
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: plan.exercises
                      .map(
                        (e) => Text(
                      "- ${e.name}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}