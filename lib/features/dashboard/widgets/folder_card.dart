import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../../../core/theme/app_theme.dart';
import '../models/training_folder.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../state/active_plan_provider.dart';
import 'plan_tile.dart';

class FolderCard extends ConsumerStatefulWidget {
  final TrainingFolder folder;

  const FolderCard({super.key, required this.folder});

  @override
  ConsumerState<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends ConsumerState<FolderCard> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final n = ref.read(dashboardProvider.notifier);
    final f = widget.folder;
    final planId = ref.read(activePlanIdProvider);

    final plans = f.plans.cast<TrainingPlan>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => expanded = !expanded),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.folder, color: AppTheme.primaryRed),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  f.bodyRegion,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final c = TextEditingController(text: f.name);
                              showDialog(
                                context: context,
                                builder: (_) => _InputDialog(
                                  title: "Ordner umbenennen",
                                  controller: c,
                                  onSubmit: (v) {
                                    if (v.isEmpty) return;
                                    n.renameFolder(f.id, v);
                                  },
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.edit, color: Colors.white54, size: 18),
                            ),
                          ),
                          Icon(
                            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white54),
                            onSelected: (v) async {
                              if (v == 'archive') n.archiveFolder(f.id);
                              if (v == 'delete') {
                                final confirm = await _confirm(context, "Ordner löschen");
                                if (confirm && planId != null) {
                                  n.deleteFolder(f.id);
                                }
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'archive', child: Text("Ordner archivieren")),
                              PopupMenuItem(value: 'delete', child: Text("Ordner löschen")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (expanded) ...[
                    ...plans.map(
                          (p) => PlanTile(
                        folderId: f.id,
                        plan: p,
                        onDelete: () => n.deletePlan(p.id),
                        onArchive: () => n.archivePlan(p.id),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final c = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (_) => _InputDialog(
                            title: "Neue Muskelgruppe",
                            controller: c,
                            onSubmit: (v) {
                              if (v.isEmpty) return;
                              n.addFolder(f.trainingPlanId, v);
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: const Text(
                          "+ Muskelgruppe hinzufügen",
                          style: TextStyle(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirm(BuildContext context, String title) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Abbrechen")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Löschen")),
        ],
      ),
    ) ??
        false;
  }
}

class _InputDialog extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final void Function(String) onSubmit;

  const _InputDialog({
    required this.title,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Abbrechen")),
            ElevatedButton(
              onPressed: () {
                onSubmit(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Speichern"),
            )
          ])
        ]),
      ),
    );
  }
}