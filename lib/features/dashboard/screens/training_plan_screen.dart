import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_list_tile.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/training_muscle_folder_tile.dart';

class TrainingPlanCard extends ConsumerStatefulWidget {
  final TrainingPlan plan;
  final bool initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const TrainingPlanCard({
    super.key,
    required this.plan,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  @override
  ConsumerState<TrainingPlanCard> createState() => _TrainingPlanCardState();
}

class _TrainingPlanCardState extends ConsumerState<TrainingPlanCard> {
  late bool open;
  static const w = 36.0;

  @override
  void initState() {
    super.initState();
    open = widget.initiallyExpanded;
  }

  void toggle() {
    setState(() => open = !open);
    widget.onExpansionChanged?.call(open);
  }

  void _confirmDelete() async {
    final confirmed = await showTTGConfirmDialog(
      context: context,
      title: "Trainingsplan löschen",
      subtitle: "Wirklich löschen?",
    );
    if (confirmed) {
      ref.read(dashboardProvider.notifier).deletePlan(widget.plan.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final groups = state.folders.where((f) =>
    f.trainingPlanId == widget.plan.id &&
        f.name.trim().isNotEmpty &&
        f.name.toLowerCase() != "allgemein");

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, open ? 16 : 12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: open ? Colors.black.withOpacity(0.35) : Colors.transparent,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: toggle,
              child: TTGListTile(
                title: widget.plan.name,
                leading: const Icon(Icons.folder, color: AppTheme.primaryRed, size: 20),
                actions: [
                  const Spacer(),
                  SizedBox(
                    width: w,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit, size: 18, color: Colors.white54),
                      onPressed: () async {
                        final controller = TextEditingController(text: widget.plan.name);
                        final result = await showDialog<String>(
                          context: context,
                          builder: (c) => AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text("Umbenennen", style: TextStyle(color: Colors.white)),
                            content: TextField(controller: controller, style: const TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(c), child: const Text("Abbrechen")),
                              TextButton(onPressed: () => Navigator.pop(c, controller.text), child: const Text("Speichern")),
                            ],
                          ),
                        );
                        if (result != null && result.trim().isNotEmpty) {
                          ref.read(dashboardProvider.notifier).renamePlan(widget.plan.id, result.trim());
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: w,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: AnimatedRotation(
                        turns: open ? .5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                      ),
                      onPressed: toggle,
                    ),
                  ),
                  SizedBox(
                    width: w,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert, size: 18, color: Colors.white54),
                      onSelected: (v) {
                        if (v == 'archive') {
                          ref.read(dashboardProvider.notifier).archivePlan(widget.plan.id);
                        } else if (v == 'delete') {
                          _confirmDelete();
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'archive', child: Text('Archivieren')),
                        PopupMenuItem(value: 'delete', child: Text('Löschen')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              child: open
                  ? Column(
                children: [
                  const SizedBox(height: 8),
                  ...groups.map((g) => TrainingFolderPlanTile(
                    folder: g,
                    plan: widget.plan,
                    onDelete: () => ref.read(dashboardProvider.notifier).deleteFolder(g.id),
                    onMoveUp: () => ref.read(dashboardProvider.notifier).moveFolderUp(g.id),
                    onMoveDown: () => ref.read(dashboardProvider.notifier).moveFolderDown(g.id),
                    onArchive: () => ref.read(dashboardProvider.notifier).archiveFolder(g.id),
                    onDuplicate: () => ref.read(dashboardProvider.notifier).duplicateFolder(g.id),
                  )),
                  const SizedBox(height: 6),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showTTGInputDialog(
                        context: context,
                        title: "Muskelgruppe hinzufügen",
                        buttonText: "Hinzufügen",
                        onSubmit: (value) {
                          if (value.trim().isNotEmpty) {
                            ref.read(dashboardProvider.notifier)
                                .addFolder(widget.plan.id, value.trim());
                          }
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "+ Muskelgruppe hinzufügen",
                        style: TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}