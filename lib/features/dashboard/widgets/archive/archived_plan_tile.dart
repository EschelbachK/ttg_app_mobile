import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/exercise.dart';
import '../../models/training_plan.dart';
import '../../state/dashboard_provider.dart';
import '../import_plan_sheet.dart';

class ArchivedPlanTile extends ConsumerStatefulWidget {
  final TrainingPlan plan;

  const ArchivedPlanTile({super.key, required this.plan});

  @override
  ConsumerState<ArchivedPlanTile> createState() =>
      _ArchivedPlanTileState();
}

class _ArchivedPlanTileState
    extends ConsumerState<ArchivedPlanTile> {
  bool expanded = false;
  bool isRemoving = false;

  void _runAction(Future<void> Function() action) async {
    setState(() => isRemoving = true);
    await Future.delayed(const Duration(milliseconds: 220));
    await action();
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.85),
                    const Color(0xFF1A0000).withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3B30).withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: -10,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Plan löschen?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Möchtest du "${widget.plan.name}" endgültig löschen?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(dialogContext),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            alignment: Alignment.center,
                            child: Text(
                              "Abbrechen",
                              style: TextStyle(
                                color:
                                Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(dialogContext);
                            _runAction(() => ref
                                .read(
                                dashboardProvider.notifier)
                                .deletePlan(widget.plan.id));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3B30),
                              borderRadius:
                              BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF3B30)
                                      .withOpacity(0.4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Text(
                              "Löschen",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openImport(BuildContext context, String folderId,
      String name, List exercises, String planId) {
    final mapped = exercises
        .map((e) => e is Exercise ? e : Exercise.fromJson(e))
        .toList();

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => ImportPlanSheet(
        plan: TrainingPlan(
          id: planId,
          name: name,
          exercises: mapped,
        ),
        folderId: folderId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final state = ref.watch(dashboardProvider);

    final folders = state.folders
        .where((f) => f.trainingPlanId == plan.id)
        .toList();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isRemoving ? 0 : 1,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: isRemoving ? 0.95 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => expanded = !expanded),
                      child: Row(
                        children: [
                          const Icon(Icons.folder,
                              color: Color(0xFFFF3B30), size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(plan.name,
                                style: const TextStyle(
                                    color: Colors.white)),
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.file_download,
                            color: Color(0xFFFF3B30)),
                        onPressed: () => _runAction(() => ref
                            .read(
                            dashboardProvider.notifier)
                            .restorePlan(plan.id)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.redAccent),
                        onPressed: () =>
                            _showDeleteDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 10),
                ...folders.map((f) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fitness_center,
                        color: Color(0xFFFF3B30),
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          f.name,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.file_download,
                            color: Color(0xFFFF3B30)),
                        onPressed: () => _openImport(
                          context,
                          f.id,
                          f.name,
                          f.exercises,
                          f.trainingPlanId,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openImport(
                          context,
                          f.id,
                          f.name,
                          f.exercises,
                          f.trainingPlanId,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                )),
              ]
            ],
          ),
        ),
      ),
    );
  }
}