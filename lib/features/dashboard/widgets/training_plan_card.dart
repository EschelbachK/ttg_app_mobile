import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import 'training_folder_plan_tile.dart';

class TrainingPlanCard extends ConsumerStatefulWidget {
  final TrainingPlan plan;
  const TrainingPlanCard({super.key, required this.plan});

  @override
  ConsumerState<TrainingPlanCard> createState() => _S();
}

class _S extends ConsumerState<TrainingPlanCard> {
  bool open = false;
  static const w = 36.0;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(dashboardProvider);
    final n = ref.read(dashboardProvider.notifier);
    final p = widget.plan;

    final groups = s.folders.where((f) =>
    f.trainingPlanId == p.id &&
        f.name.trim().isNotEmpty &&
        f.name.toLowerCase() != "allgemein");

    return Padding(
      padding: EdgeInsets.only(bottom: open ? 16 : 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(.015),
          border: Border.all(color: Colors.white.withOpacity(.15)),
        ),
        child: Column(children: [
          GestureDetector(
            onTap: () => setState(() => open = !open),
            child: Row(children: [
              const SizedBox(
                width: 30,
                child: Icon(Icons.folder,
                    color: AppTheme.primaryRed, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(p.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: w,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit,
                        size: 18, color: Colors.white54),
                    onPressed: () => showTTGInputDialog(
                      context: context,
                      title: "Trainingsplan umbenennen",
                      buttonText: "Speichern",
                      initialValue: p.name,
                      onSubmit: (v) => n.renamePlan(p.id, v),
                    ),
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
                    onPressed: () => setState(() => open = !open),
                  ),
                ),
                SizedBox(
                  width: w,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert,
                        color: Colors.white54),
                    onSelected: (v) {
                      if (v == 'delete') n.deletePlan(p.id);
                      if (v == 'archive') n.archivePlan(p.id);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'archive', child: Text('Archivieren')),
                      PopupMenuItem(value: 'delete', child: Text('Löschen')),
                    ],
                  ),
                ),
              ])
            ]),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: open
                ? Column(children: [
              const SizedBox(height: 8),
              ...groups.map((g) => PlanTile(
                folder: g,
                onDelete: () => n.deleteFolder(g.id),
                onMoveUp: () => n.moveFolderUp(g.id),
                onMoveDown: () => n.moveFolderDown(g.id),
                onArchive: () => n.archiveFolder(g.id),
                onDuplicate: () => n.duplicateFolder(g.id),
              )),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => showTTGInputDialog(
                  context: context,
                  title: "Neue Muskelgruppe",
                  buttonText: "Erstellen",
                  onSubmit: (v) => n.addFolder(p.id, v),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("+ Muskelgruppe hinzufügen",
                      style: TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ])
                : const SizedBox(),
          )
        ]),
      ),
    );
  }
}