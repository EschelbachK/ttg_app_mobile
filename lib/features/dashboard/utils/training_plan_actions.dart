import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../state/dashboard_provider.dart';
import '../models/training_plan.dart';

class TrainingPlanActions {
  static void rename(
      BuildContext context,
      WidgetRef ref,
      TrainingPlan plan,
      ) {
    final n = ref.read(dashboardProvider.notifier);

    showTTGInputDialog(
      context: context,
      title: "Trainingsplan umbenennen",
      buttonText: "Speichern",
      initialValue: plan.name,
      onSubmit: (v) => n.renamePlan(plan.id, v),
    );
  }

  static void createFolder(
      BuildContext context,
      WidgetRef ref,
      String planId,
      ) {
    final n = ref.read(dashboardProvider.notifier);

    showTTGInputDialog(
      context: context,
      title: "Neue Muskelgruppe",
      buttonText: "Erstellen",
      onSubmit: (v) => n.addFolder(planId, v),
    );
  }

  static void handleMenu(
      WidgetRef ref,
      String value,
      String planId,
      ) {
    final n = ref.read(dashboardProvider.notifier);

    if (value == 'delete') n.deletePlan(planId);
    if (value == 'archive') n.archivePlan(planId);
  }
}