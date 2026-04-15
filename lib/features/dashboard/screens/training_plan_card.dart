import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_list_tile.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../../../core/ui/ttg_popup_menu.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/training_muscle_folder_tile.dart';

class TrainingPlanCard extends ConsumerStatefulWidget {
  final TrainingPlan plan;
  final String? expandedPlanId;
  final Function(String?) onExpand;

  const TrainingPlanCard({
    super.key,
    required this.plan,
    required this.expandedPlanId,
    required this.onExpand,
  });

  @override
  ConsumerState<TrainingPlanCard> createState() => _TrainingPlanCardState();
}

class _TrainingPlanCardState extends ConsumerState<TrainingPlanCard> {
  static const w = 36.0;

  bool get open => widget.expandedPlanId == widget.plan.id;

  void toggle() {
    if (open) {
      widget.onExpand(null);
    } else {
      widget.onExpand(widget.plan.id);
    }
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
              behavior: HitTestBehavior.translucent,
              onTap: toggle,
              child: TTGListTile(
                title: widget.plan.name,
                leading: const Icon(Icons.folder, color: AppTheme.primaryRed),
                actions: [
                  const Spacer(),

                  SizedBox(
                    width: w,
                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          size: 18, color: Colors.white54),
                      onPressed: () async {
                        final controller =
                        TextEditingController(text: widget.plan.name);

                        final result = await showDialog<String>(
                          context: context,
                          builder: (c) => AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text("Umbenennen",
                                style: TextStyle(color: Colors.white)),
                            content: TextField(
                                controller: controller,
                                style:
                                const TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(c),
                                  child: const Text("Abbrechen")),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(c, controller.text),
                                  child: const Text("Speichern")),
                            ],
                          ),
                        );

                        if (result != null && result.trim().isNotEmpty) {
                          ref
                              .read(dashboardProvider.notifier)
                              .renamePlan(widget.plan.id, result.trim());
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    width: w,
                    child: IconButton(
                      icon: AnimatedRotation(
                        turns: open ? .5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                      onPressed: toggle,
                    ),
                  ),

                  SizedBox(
                    width: w,
                    child: TTGPopupMenu(
                      onSelected: (v) {
                        final n =
                        ref.read(dashboardProvider.notifier);

                        if (v == 'up') n.movePlanUp(widget.plan.id);
                        if (v == 'down') n.movePlanDown(widget.plan.id);
                        if (v == 'archive') n.archivePlan(widget.plan.id);
                        if (v == 'delete') _confirmDelete();
                      },
                      items: const [
                        PopupMenuItem(
                          value: 'archive',
                          child: Text('Archivieren'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Löschen'),
                        ),
                        PopupMenuItem(
                          enabled: false,
                          padding: EdgeInsets.zero,
                          height: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: _TTGMenuDivider(),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'up',
                          child: Row(
                            children: [
                              Icon(Icons.arrow_upward,
                                  color: AppTheme.primaryRed),
                              SizedBox(width: 8),
                              Text('Nach oben'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'down',
                          child: Row(
                            children: [
                              Icon(Icons.arrow_downward,
                                  color: AppTheme.primaryRed),
                              SizedBox(width: 8),
                              Text('Nach unten'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (open)
              Column(
                children: [
                  const SizedBox(height: 8),

                  ...groups.map((g) => TrainingFolderPlanTile(
                    folder: g,
                    plan: widget.plan,
                    onDelete: () => ref
                        .read(dashboardProvider.notifier)
                        .deleteFolder(g.id),
                    onMoveUp: () => ref
                        .read(dashboardProvider.notifier)
                        .moveFolderUp(g.id),
                    onMoveDown: () => ref
                        .read(dashboardProvider.notifier)
                        .moveFolderDown(g.id),
                    onArchive: () => ref
                        .read(dashboardProvider.notifier)
                        .archiveFolder(g.id),
                    onDuplicate: () => ref
                        .read(dashboardProvider.notifier)
                        .duplicateFolder(g.id),
                  )),

                  const SizedBox(height: 6),

                  GestureDetector(
                    onTap: () {
                      showTTGInputDialog(
                        context: context,
                        title: "Muskelgruppe hinzufügen",
                        buttonText: "Hinzufügen",
                        onSubmit: (value) async {
                          if (value.trim().isEmpty) return;

                          await ref
                              .read(dashboardProvider.notifier)
                              .addFolder(
                              widget.plan.id, value.trim());
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
          ],
        ),
      ),
    );
  }
}

class _TTGMenuDivider extends StatelessWidget {
  const _TTGMenuDivider();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 1,
          color: Colors.white.withOpacity(0.15),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}