import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/workout_api_service.dart';
import '../models/training_plan.dart';
import '../models/training_folder.dart';
import '../models/training_exercise.dart';
import '../models/set_entry.dart';

// =========================
// API SERVICE
// =========================

final workoutApiServiceProvider =
Provider<WorkoutApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return WorkoutApiService(dio);
});

// =========================
// TRAINING PLAN
// =========================

final trainingPlansProvider =
FutureProvider<List<TrainingPlan>>((ref) async {
  final api = ref.watch(workoutApiServiceProvider);
  return api.getTrainingPlans();
});

// =========================
// TRAINING FOLDER
// =========================

final foldersProvider =
FutureProvider.family<List<TrainingFolder>, String>(
        (ref, planId) async {
      final api = ref.watch(workoutApiServiceProvider);
      return api.getFolders(planId);
    });

// =========================
// TRAINING EXERCISE
// =========================

final exercisesProvider =
FutureProvider.family<List<TrainingExercise>, String>(
        (ref, folderId) async {
      final api = ref.watch(workoutApiServiceProvider);
      return api.getExercises(folderId);
    });

// =========================
// SET ENTRY
// =========================

final setsProvider =
FutureProvider.family<List<SetEntry>, String>(
        (ref, exerciseId) async {
      final api = ref.watch(workoutApiServiceProvider);
      return api.getSets(exerciseId);
    });