import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/training_plan.dart';
import '../../state/dashboard_provider.dart';
import '../../screens/muscle_group_screen.dart';
import '../import_plan_sheet.dart';

class ArchivedPlanTile extends ConsumerStatefulWidget {
  final TrainingPlan plan;

  const ArchivedPlanTile({
    super.key,
    required this.plan,
  });

  @override
  ConsumerState<ArchivedPlanTile> createState() => _ArchivedPlanTileState();
}

class _ArchivedPlanTileState extends ConsumerState<ArchivedPlanTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final state = ref.watch(dashboardProvider);

    final folders = state.folders
        .where((f) => f.trainingPlanId == plan.id)
        .toList();

    return Container(
      key: ValueKey(plan.id),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.file_download,
                  color: Color(0xFFFF3B30),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (_) => ImportPlanSheet(plan: plan),
                  );
                },
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 10),
            if (folders.isEmpty)
              const Text(
                "Keine Muskelgruppen vorhanden",
                style: TextStyle(color: Colors.white38),
              ),
            ...folders.map((folder) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MuscleGroupScreen(
                          folderId: folder.id,
                          plan: TrainingPlan(
                            id: folder.trainingPlanId,
                            name: folder.name,
                            exercises: folder.exercises,
                          ),
                          isArchived: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      folder.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}