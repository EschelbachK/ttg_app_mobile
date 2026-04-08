import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../state/active_plan_provider.dart';
import '../screens/muscle_group_screen.dart';

class PlanTileActions {
  static void openPlan(
      BuildContext context,
      WidgetRef ref, {
        required String folderId,
        required TrainingPlan plan,
        required bool isArchived,
      }) {
    ref.read(activePlanIdProvider.notifier).state = plan.id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MuscleGroupScreen(
          folderId: folderId,
          plan: plan,
          isArchived: isArchived,
        ),
      ),
    );
  }

  static void rename(
      BuildContext context,
      WidgetRef ref,
      TrainingPlan plan,
      ) {
    final notifier = ref.read(dashboardProvider.notifier);

    showTTGInputDialog(
      context: context,
      title: "Muskelgruppe umbenennen",
      buttonText: "Speichern",
      initialValue: plan.name,
      onSubmit: (value) => notifier.renamePlan(plan.id, value),
    );
  }

  static Future<void> delete(
      BuildContext context,
      VoidCallback onDelete,
      ) async {
    final confirm = await showTTGConfirmDialog(
      context: context,
      title: "Muskelgruppe löschen",
      subtitle: "Wirklich löschen?",
    );
    if (confirm) onDelete();
  }

  static void importExercise(
      WidgetRef ref,
      String folderId,
      String planId,
      dynamic exercise,
      ) {
    ref.read(dashboardProvider.notifier).importExercise(
      folderId,
      planId,
      exercise,
    );
  }
}