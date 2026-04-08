import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_list_tile.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../utils/training_plan_actions.dart';
import 'training_folder_plan_tile.dart';

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
  ConsumerState<TrainingPlanCard> createState() => _S();
}

class _S extends ConsumerState<TrainingPlanCard> {
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

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(dashboardProvider);
    final p = widget.plan;

    final groups = s.folders.where((f) =>
    f.trainingPlanId == p.id &&
        f.name.trim().isNotEmpty &&
        f.name.toLowerCase() != "allgemein");

    final container = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: open ? Colors.black.withOpacity(0.35) : Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: toggle,
            child: TTGListTile(
              title: p.name,
              leading: const Icon(Icons.folder,
                  color: AppTheme.primaryRed, size: 20),
              actions: [
                SizedBox(
                  width: w,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit,
                        size: 18, color: Colors.white54),
                    onPressed: () =>
                        TrainingPlanActions.rename(context, ref, p),
                  ),
                ),
                SizedBox(
                  width: w,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: AnimatedRotation(
                      turns: open ? .5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54),
                    ),
                    onPressed: toggle,
                  ),
                ),
                SizedBox(
                  width: w,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert,
                        color: Colors.white54),
                    onSelected: (v) =>
                        TrainingPlanActions.handleMenu(ref, v, p.id),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: 'archive',
                          child: Text('Archivieren')),
                      PopupMenuItem(
                          value: 'delete', child: Text('Löschen')),
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
                  onTap: () => TrainingPlanActions.createFolder(
                      context, ref, p.id),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "+ Muskelgruppe hinzufügen",
                      style: TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
                : const SizedBox(),
          )
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, open ? 16 : 12),
      child: open ? TTGGlowBorder(child: container) : container,
    );
  }
}