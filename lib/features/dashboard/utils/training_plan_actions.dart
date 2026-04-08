import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';

class TrainingPlanActions {
  static void createFolder(
      BuildContext context, WidgetRef ref, String planId) {
    showTTGInputDialog(
      context: context,
      title: "Muskelgruppe erstellen",
      buttonText: "Erstellen",
      onSubmit: (value) => ref
          .read(dashboardProvider.notifier)
          .addFolder(planId, value),
    );
  }

  static void rename(
      BuildContext context, WidgetRef ref, TrainingPlan plan) {
    showTTGInputDialog(
      context: context,
      title: "Plan umbenennen",
      initialValue: plan.name,
      buttonText: "Speichern",
      onSubmit: (value) => ref
          .read(dashboardProvider.notifier)
          .renamePlan(plan.id, value),
    );
  }

  static void handleMenu(
      WidgetRef ref, String value, String planId) {
    final n = ref.read(dashboardProvider.notifier);

    if (value == 'archive') n.archivePlan(planId);
    if (value == 'delete') n.deletePlan(planId);
  }
}