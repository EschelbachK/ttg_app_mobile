import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../state/dashboard_provider.dart';
import '../models/training_folder.dart';
import '../models/training_plan.dart';
import '../screens/muscle_group_screen.dart';

class PlanTile extends ConsumerWidget {
  final TrainingFolder folder;
  final VoidCallback onDelete, onMoveUp, onMoveDown, onArchive, onDuplicate;

  const PlanTile({
    super.key,
    required this.folder,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onArchive,
    required this.onDuplicate,
  });

  static const w = 36.0;

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final n = ref.read(dashboardProvider.notifier);

    return GestureDetector(
      onTap: () => Navigator.push(
        c,
        MaterialPageRoute(
          builder: (_) => MuscleGroupScreen(
            folderId: folder.id,
            plan: TrainingPlan(
              id: folder.trainingPlanId,
              name: folder.name,
              exercises: folder.exercises,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(.015),
            border: Border.all(color: Colors.white.withOpacity(.15)),
          ),
          child: Row(children: [
            const SizedBox(
              width: 30,
              child: Icon(Icons.fitness_center,
                  color: AppTheme.primaryRed, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(folder.name,
                  style: const TextStyle(color: Colors.white)),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: w,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit,
                      size: 18, color: Colors.white54),
                  onPressed: () => showTTGInputDialog(
                    context: c,
                    title: "Muskelgruppe umbenennen",
                    buttonText: "Speichern",
                    initialValue: folder.name,
                    onSubmit: (v) => n.renameFolder(folder.id, v),
                  ),
                ),
              ),
              SizedBox(
                width: w,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon:
                  const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
              SizedBox(
                width: w,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert,
                      color: Colors.white54),
                  onSelected: (v) {
                    if (v == 'up') onMoveUp();
                    if (v == 'down') onMoveDown();
                    if (v == 'duplicate') onDuplicate();
                    if (v == 'archive') onArchive();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'up', child: Text('Nach oben')),
                    PopupMenuItem(value: 'down', child: Text('Nach unten')),
                    PopupMenuItem(value: 'duplicate', child: Text('Duplizieren')),
                    PopupMenuItem(value: 'archive', child: Text('Archivieren')),
                  ],
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}