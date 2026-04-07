import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/training_folder.dart';
import '../../screens/muscle_group_screen.dart';
import '../../state/dashboard_provider.dart';
import '../../models/training_plan.dart';

class ArchivedFolderTile extends ConsumerWidget {
  final TrainingFolder folder;

  const ArchivedFolderTile({
    super.key,
    required this.folder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: ValueKey(folder.id),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.folder,
            color: Color(0xFFFF3B30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    folder.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  folder.trainingPlanName,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.file_download,
              color: Color(0xFFFF3B30),
            ),
            onPressed: () {
              ref.read(dashboardProvider.notifier).importFolder(folder);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onPressed: () {
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
          ),
        ],
      ),
    );
  }
}