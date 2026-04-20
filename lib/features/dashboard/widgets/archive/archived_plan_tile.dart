import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/training_plan.dart';
import '../../state/dashboard_provider.dart';
import '../../utils/dashboard_mapper.dart';
import '../import_plan_sheet.dart';
import '../../../../core/theme/app_theme.dart';

class ArchivedPlanTile extends ConsumerStatefulWidget {
  final TrainingPlan plan;

  const ArchivedPlanTile({super.key, required this.plan});

  @override
  ConsumerState<ArchivedPlanTile> createState() =>
      _ArchivedPlanTileState();
}

class _ArchivedPlanTileState extends ConsumerState<ArchivedPlanTile> {
  bool expanded = false;
  bool isRemoving = false;

  void _runAction(Future<void> Function() action) async {
    setState(() => isRemoving = true);
    await Future.delayed(const Duration(milliseconds: 220));
    await action();
  }

  void _showDeleteDialog(BuildContext context) {
    final theme = Theme.of(context);

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
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryRed.withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: -10,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Plan löschen?",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 10),
                  Text(
                    'Möchtest du "${widget.plan.name}" endgültig löschen?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(dialogContext),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            child: Text(
                              "Abbrechen",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.6),
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
                                .read(dashboardProvider.notifier)
                                .deletePlan(widget.plan.id));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "Löschen",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
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
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => ImportPlanSheet(
        plan: TrainingPlan(
          id: planId,
          name: name,
          exercises:
          DashboardMapper.mapExercises(exercises),
        ),
        folderId: folderId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

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
          margin: const EdgeInsets.only(bottom: 12),
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.surface.withOpacity(
                theme.brightness == Brightness.dark ? 0.35 : 0.95),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.2),
            ),
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
                              color: AppTheme.primaryRed, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              plan.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: theme.iconTheme.color?.withOpacity(0.6),
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
                            color: AppTheme.primaryRed, size: 25),
                        onPressed: () => _runAction(() => ref
                            .read(dashboardProvider.notifier)
                            .restorePlan(plan.id)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppTheme.primaryRed, size: 25),
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
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surface.withOpacity(
                        theme.brightness == Brightness.dark
                            ? 0.35
                            : 1),
                    border: Border.all(
                      color:
                      theme.dividerColor.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fitness_center,
                          color: AppTheme.primaryRed, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f.name,
                          style:
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed
                              .withOpacity(0.15),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                            color: AppTheme.primaryRed,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.file_download,
                            color: AppTheme.primaryRed, size: 25),
                        onPressed: () => _openImport(
                          context,
                          f.id,
                          f.name,
                          f.exercises,
                          f.trainingPlanId,
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