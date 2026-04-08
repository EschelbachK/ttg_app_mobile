import 'package:flutter/material.dart';
import '../models/training_plan.dart';
import '../utils/dashboard_mapper.dart';
import '../widgets/import_plan_sheet.dart';

class ArchiveActions {
  static void openImport(
      BuildContext context, {
        required String folderId,
        required String planId,
        required String name,
        required List exercises,
      }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => ImportPlanSheet(
        plan: TrainingPlan(
          id: planId,
          name: name,
          exercises: DashboardMapper.mapExercises(exercises),
        ),
        folderId: folderId,
      ),
    );
  }
}