import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/training_plan.dart';
import '../../models/exercise.dart';
import '../../state/dashboard_provider.dart';

class ArchivedMuscleGroupTile extends ConsumerStatefulWidget {
  final TrainingPlan plan;
  final String folderId;
  final String targetPlanId;

  const ArchivedMuscleGroupTile({
    super.key,
    required this.plan,
    required this.folderId,
    required this.targetPlanId,
  });

  @override
  ConsumerState<ArchivedMuscleGroupTile> createState() =>
      _ArchivedMuscleGroupTileState();
}

class _ArchivedMuscleGroupTileState
    extends ConsumerState<ArchivedMuscleGroupTile> {

  bool expanded = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [

          InkWell(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Row(
              children: [

                const Icon(
                  Icons.fitness_center,
                  color: Color(0xFFFF3B30),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    widget.plan.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: Color(0xFFFF3B30),
                  ),
                  onPressed: () {
                    for (final e in widget.plan.exercises) {
                      ref.read(dashboardProvider.notifier).importExercise(
                        widget.folderId,
                        widget.targetPlanId,
                        e,
                      );
                    }
                  },
                ),

                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white54,
                ),
              ],
            ),
          ),

          if (expanded) ...[
            const SizedBox(height: 12),

            ...widget.plan.exercises.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [

                    Expanded(
                      child: Text(
                        e.name,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.download,
                        color: Color(0xFFFF3B30),
                      ),
                      onPressed: () {
                        ref.read(dashboardProvider.notifier).importExercise(
                          widget.folderId,
                          widget.targetPlanId,
                          e,
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}