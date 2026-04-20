import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../../../core/ui/ttg_popup_menu.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/musclegroup_folder_tile.dart';

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
    widget.onExpand(open ? null : widget.plan.id);
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
    final theme = Theme.of(context);

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
          color: open
              ? theme.colorScheme.surface.withOpacity(
              theme.brightness == Brightness.dark ? 0.35 : 0.9)
              : Colors.transparent,
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: toggle,
              child: Row(
                children: [
                  const Icon(Icons.folder, color: AppTheme.primaryRed),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      widget.plan.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: w,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: theme.iconTheme.color?.withOpacity(0.6),
                          ),
                          onPressed: () {
                            showTTGInputDialog(
                              context: context,
                              title: "Plan umbenennen",
                              buttonText: "Speichern",
                              initialValue: widget.plan.name,
                              onSubmit: (value) {
                                ref
                                    .read(dashboardProvider.notifier)
                                    .renamePlan(widget.plan.id, value);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: w,
                        child: IconButton(
                          icon: AnimatedRotation(
                            turns: open ? .5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: theme.iconTheme.color?.withOpacity(0.6),
                            ),
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

                            if (v == 'archive') n.archivePlan(widget.plan.id);
                            if (v == 'delete') _confirmDelete();
                            if (v == 'up') n.movePlanUp(widget.plan.id);
                            if (v == 'down') n.movePlanDown(widget.plan.id);
                          },
                          items: [
                            PopupMenuItem(
                              value: 'archive',
                              child: Row(
                                children: [
                                  const Icon(Icons.archive_outlined,
                                      size: 18,
                                      color: AppTheme.primaryRed),
                                  const SizedBox(width: 10),
                                  Text('Archivieren',
                                      style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(Icons.delete_outline,
                                      size: 18,
                                      color: AppTheme.primaryRed),
                                  const SizedBox(width: 10),
                                  Text('Löschen',
                                      style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              enabled: false,
                              padding:
                              EdgeInsets.symmetric(horizontal: 12),
                              height: 14,
                              child: _TTGMenuDivider(),
                            ),
                            PopupMenuItem(
                              value: 'up',
                              child: Row(
                                children: [
                                  const Icon(Icons.arrow_upward,
                                      color: AppTheme.primaryRed),
                                  const SizedBox(width: 8),
                                  Text('Nach oben',
                                      style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'down',
                              child: Row(
                                children: [
                                  const Icon(Icons.arrow_downward,
                                      color: AppTheme.primaryRed),
                                  const SizedBox(width: 8),
                                  Text('Nach unten',
                                      style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    onRename: () {
                      showTTGInputDialog(
                        context: context,
                        title: "Muskelgruppe umbenennen",
                        buttonText: "Speichern",
                        initialValue: g.name,
                        onSubmit: (value) {
                          ref
                              .read(dashboardProvider.notifier)
                              .renameFolder(g.id, value);
                        },
                      );
                    },
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "+ Muskelgruppe hinzufügen",
                        style: theme.textTheme.bodyMedium?.copyWith(
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
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          color: Theme.of(context).dividerColor,
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