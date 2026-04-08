import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../../dashboard/models/training_plan.dart';
import '../../dashboard/models/training_folder.dart';
import '../data/workout_api_service.dart';
import '../models/training_exercise.dart';
import '../models/set_entry.dart';

final workoutApiServiceProvider = Provider(
      (ref) => WorkoutApiService(ref.watch(dioProvider)),
);

final trainingPlansProvider =
FutureProvider<List<TrainingPlan>>(
        (ref) => ref.read(workoutApiServiceProvider).getTrainingPlans());

final foldersProvider =
FutureProvider.family<List<TrainingFolder>, String>(
        (ref, planId) =>
        ref.read(workoutApiServiceProvider).getFolders(planId));

final exercisesProvider =
FutureProvider.family<List<TrainingExercise>, String>(
        (ref, folderId) =>
        ref.read(workoutApiServiceProvider).getExercises(folderId));

final setsProvider =
FutureProvider.family<List<SetEntry>, String>(
        (ref, exerciseId) =>
        ref.read(workoutApiServiceProvider).getSets(exerciseId));