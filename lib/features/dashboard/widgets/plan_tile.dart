import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../models/training_plan.dart';
import '../state/active_plan_provider.dart';
import '../screens/muscle_group_screen.dart';
import '../state/dashboard_provider.dart';

class PlanTile extends ConsumerStatefulWidget {
  final String folderId;
  final TrainingPlan plan;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final bool isArchived;

  const PlanTile({
    super.key,
    required this.folderId,
    required this.plan,
    required this.onDelete,
    required this.onArchive,
    this.isArchived = false,
  });

  @override
  ConsumerState<PlanTile> createState() => _PlanTileState();
}

class _PlanTileState extends ConsumerState<PlanTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(dashboardProvider.notifier);
    final plan = widget.plan;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            ref.read(activePlanIdProvider.notifier).state = plan.id;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MuscleGroupScreen(
                                  folderId: widget.folderId,
                                  plan: plan,
                                  isArchived: widget.isArchived,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.fitness_center, color: Color(0xFFFF3B30)),
                              const SizedBox(width: 10),
                              Text(
                                plan.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (widget.isArchived)
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                          onPressed: () => setState(() => expanded = !expanded),
                        ),

                      if (!widget.isArchived)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showTTGInputDialog(
                                  context: context,
                                  title: "Muskelgruppe umbenennen",
                                  buttonText: "Speichern",
                                  initialValue: plan.name,
                                  onSubmit: (value) {
                                    notifier.renamePlan(plan.id, value);
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(Icons.edit, color: Color(0xFFFF3B30), size: 18),
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                final confirm = await showTTGConfirmDialog(
                                  context: context,
                                  title: "Muskelgruppe löschen",
                                  subtitle: "Wirklich löschen?",
                                );
                                if (confirm) widget.onDelete();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(Icons.delete, color: Color(0xFFFF3B30), size: 18),
                              ),
                            ),

                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
                              onSelected: (value) async {
                                if (value == 'archive') widget.onArchive();

                                if (value == 'delete') {
                                  final confirm = await showTTGConfirmDialog(
                                    context: context,
                                    title: "Muskelgruppe löschen",
                                    subtitle: "Wirklich löschen?",
                                  );
                                  if (confirm) widget.onDelete();
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'archive',
                                  child: Text('Gruppe archivieren'),
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Löschen'),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                if (expanded && widget.isArchived)
                  Column(
                    children: plan.exercises.map((group) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  group.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                ref.read(dashboardProvider.notifier).importExercise(
                                  widget.folderId,
                                  plan.id,
                                  group,
                                );
                              },
                              child: const Icon(
                                Icons.download,
                                color: Color(0xFFFF3B30),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}