import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../state/dashboard_provider.dart';
import '../models/training_folder.dart';
import '../screens/muscle_group_screen.dart';
import '../models/training_plan.dart';

class PlanTile extends ConsumerWidget {
  final TrainingFolder folder;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onArchive;
  final VoidCallback onDuplicate;

  const PlanTile({
    super.key,
    required this.folder,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onArchive,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);

    return GestureDetector(
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
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    color: AppTheme.primaryRed,
                    size: 18,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      folder.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  /// RENAME
                  IconButton(
                    icon: const Icon(Icons.edit,
                        size: 18, color: Colors.white54),
                    onPressed: () {
                      final controller =
                      TextEditingController(text: folder.name);

                      showDialog(
                        context: context,
                        builder: (dialogContext) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: controller,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    final name =
                                    controller.text.trim();
                                    if (name.isEmpty) return;

                                    Navigator.pop(dialogContext);

                                    notifier.renameFolder(
                                      folder.id,
                                      name,
                                    );
                                  },
                                  child: const Text("Speichern"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete,
                        size: 18, color: Colors.red),
                    onPressed: onDelete,
                  ),

                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        color: Colors.white54),
                    onSelected: (value) {
                      switch (value) {
                        case 'up':
                          onMoveUp();
                          break;
                        case 'down':
                          onMoveDown();
                          break;
                        case 'duplicate':
                          onDuplicate();
                          break;
                        case 'archive':
                          onArchive();
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                          value: 'up', child: Text('Nach oben')),
                      PopupMenuItem(
                          value: 'down', child: Text('Nach unten')),
                      PopupMenuItem(
                          value: 'duplicate',
                          child: Text('Duplizieren')),
                      PopupMenuItem(
                          value: 'archive',
                          child: Text('Archivieren')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}