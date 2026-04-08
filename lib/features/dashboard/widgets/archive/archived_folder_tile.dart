import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/training_folder.dart';
import '../../utils/archive_actions.dart';

class ArchivedFolderTile extends ConsumerWidget {
  final TrainingFolder folder;

  const ArchivedFolderTile({
    super.key,
    required this.folder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.35),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center,
              color: Color(0xFFFF3B30), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              folder.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              folder.trainingPlanName,
              style: const TextStyle(
                color: Color(0xFFFF3B30),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.file_download,
                color: Color(0xFFFF3B30), size: 25),
            onPressed: () => ArchiveActions.openImport(
              context,
              folderId: folder.id,
              planId: folder.trainingPlanId,
              name: folder.name,
              exercises: folder.exercises,
            ),
          ),
        ],
      ),
    );
  }
}