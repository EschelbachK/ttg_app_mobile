import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/training_plan.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 HEADER
          Row(
            children: [

              /// 🔥 CLICK AREA
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

                      /// 🔥 ICON FIXED (kein Asset mehr!)
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

                      if (plan.originFolderName != null &&
                          plan.originFolderName!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            plan.originFolderName!,
                            style: const TextStyle(
                              color: Color(0xFFFF3B30),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
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

              /// 🔥 IMPORT BUTTON
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

          /// 🔥 EXPANDED CONTENT
          if (expanded) ...[

            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plan.exercises.map((exercise) {

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),

                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MuscleGroupScreen(
                            folderId: "archived",
                            plan: plan,
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
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          ],
        ],
      ),
    );
  }
}