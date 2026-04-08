import 'package:flutter/material.dart';
import '../../workout/models/training_folder.dart';

class TrainingFolderPlanTile extends StatelessWidget {
  final TrainingFolder folder;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onArchive;
  final VoidCallback onDuplicate;

  const TrainingFolderPlanTile({
    super.key,
    required this.folder,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onArchive,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              folder.name,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 16),
            onPressed: onMoveUp,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 16),
            onPressed: onMoveDown,
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: onDuplicate,
          ),
          IconButton(
            icon: const Icon(Icons.archive, size: 16),
            onPressed: onArchive,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 16),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}