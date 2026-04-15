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
  final VoidCallback onRename;

  const TrainingFolderPlanTile({
    super.key,
    required this.folder,
    required this.plan,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onArchive,
    required this.onDuplicate,
    required this.onRename,
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
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onMoveUp,
                  child: const Icon(
                    Icons.arrow_upward,
                    size: 18,
                    color: AppTheme.primaryRed,
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: onMoveDown,
                  child: const Icon(
                    Icons.arrow_downward,
                    size: 18,
                    color: AppTheme.primaryRed,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            TTGPopupMenu(
              onSelected: (v) {
                if (v == 'rename') onRename();
                if (v == 'copy') onDuplicate();
                if (v == 'archive') onArchive();
                if (v == 'delete') onDelete();
              },
              items: const [
                PopupMenuItem(
                  value: 'rename',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: AppTheme.primaryRed),
                      SizedBox(width: 10),
                      Text(
                        'Umbenennen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: 18, color: AppTheme.primaryRed),
                      SizedBox(width: 10),
                      Text(
                        'Kopieren',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  enabled: false,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: 14,
                  child: _TTGGlowDivider(),
                ),
                PopupMenuItem(
                  value: 'archive',
                  child: Row(
                    children: [
                      Icon(Icons.archive_outlined,
                          size: 18, color: AppTheme.primaryRed),
                      SizedBox(width: 10),
                      Text(
                        'Archivieren',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 18, color: AppTheme.primaryRed),
                      SizedBox(width: 10),
                      Text(
                        'Löschen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TTGGlowDivider extends StatelessWidget {
  const _TTGGlowDivider();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          color: Colors.redAccent.withOpacity(0.6),
        ),
        Container(
          height: 2,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(1),
                blurRadius: 20,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.8),
                blurRadius: 40,
                spreadRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}