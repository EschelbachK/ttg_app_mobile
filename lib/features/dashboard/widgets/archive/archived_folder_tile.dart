// 🔧 FIX: Badge + Layout wie Bild 2 + sauberer Row Aufbau

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/training_folder.dart';
import '../../screens/muscle_group_screen.dart';
import '../../models/training_plan.dart';
import '../import_plan_sheet.dart';

class ArchivedFolderTile extends ConsumerWidget {
  final TrainingFolder folder;

  const ArchivedFolderTile({
    super.key,
    required this.folder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center,
              color: Color(0xFFFF3B30)),
          const SizedBox(width: 12),

          /// NAME + BADGE
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    folder.name,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16),
                  ),
                ),

                /// 🔥 BADGE FIX
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    folder.trainingPlanName,
                    style: const TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.file_download,
                color: Color(0xFFFF3B30)),
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (_) => ImportPlanSheet(
                  plan: TrainingPlan(
                    id: folder.trainingPlanId,
                    name: folder.name,
                    exercises: folder.exercises,
                  ),
                  folderId: folder.id,
                ),
              );
            },
          ),

          const Icon(Icons.arrow_forward_ios,
              color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}