import 'package:flutter/material.dart';
import '../models/training_folder.dart';

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
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_upward, size: 16),
            onPressed: onMoveUp,
          ),
          const SizedBox(width: 6),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_downward, size: 16),
            onPressed: onMoveDown,
          ),
          const SizedBox(width: 6),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert, size: 18, color: Colors.white54),
            onSelected: (v) {
              if (v == 'copy') onDuplicate();
              if (v == 'archive') onArchive();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'copy', child: Text('Kopieren')),
              PopupMenuItem(value: 'archive', child: Text('Archivieren')),
              PopupMenuItem(value: 'delete', child: Text('Löschen')),
            ],
          ),
        ],
      ),
    );
  }
}