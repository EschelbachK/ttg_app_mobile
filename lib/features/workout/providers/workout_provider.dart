import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/workout_controller.dart';
import '../application/workout_state.dart';
import '../data/workout_api_service.dart';

final workoutApiProvider =
Provider<WorkoutApiService>((ref) => ref.read(workoutApiServiceProvider));

final workoutProvider =
StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
  final controller = WorkoutController(ref.read(workoutApiProvider));
  Future.microtask(controller.init);
  return controller;
});