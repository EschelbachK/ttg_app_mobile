import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../state/dashboard_provider.dart';

class ArchiveExerciseActions {
  static Future<void> importAll(
      WidgetRef ref, {
        required String folderId,
        required String planId,
        required List<Exercise> exercises,
      }) async {
    for (final e in exercises) {
      await ref.read(dashboardProvider.notifier).importExercise(
        folderId,
        planId,
        e,
      );
    }
  }

  static Future<void> importSingle(
      WidgetRef ref, {
        required String folderId,
        required String planId,
        required Exercise exercise,
      }) async {
    await ref.read(dashboardProvider.notifier).importExercise(
      folderId,
      planId,
      exercise,
    );
  }
}