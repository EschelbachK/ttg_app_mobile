import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_list_tile.dart';
import '../../../core/ui/ttg_popup_menu.dart';
import '../models/training_plan.dart';
import '../models/training_folder.dart';

class TrainingFolderPlanTile extends StatelessWidget {
  final TrainingFolder folder;
  final TrainingPlan plan;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onArchive;
  final VoidCallback onDuplicate;

  const TrainingFolderPlanTile({
    super.key,
    required this.folder,
    required this.plan,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onArchive,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
        '/dashboard/muscle-group/${folder.id}',
        extra: plan,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [

            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryRed,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryRed.withOpacity(0.9),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                folder.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  fontSize: 16, //
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_upward,
                size: 20,
                color: AppTheme.primaryRed,
              ),
              onPressed: onMoveUp,
            ),

            const SizedBox(width: 6),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_downward,
                size: 20,
                color: AppTheme.primaryRed,
              ),
              onPressed: onMoveDown,
            ),

            const SizedBox(width: 6),

            TTGPopupMenu(
              onSelected: (v) {
                if (v == 'copy') onDuplicate();
                if (v == 'archive') onArchive();
                if (v == 'delete') onDelete();
              },
              items: const [
                PopupMenuItem(
                  value: 'copy',
                  child: Text('Kopieren'),
                ),
                PopupMenuItem(
                  value: 'archive',
                  child: Text('Archivieren'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Löschen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}