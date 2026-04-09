import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/workout/application/workout_controller.dart';
import 'package:ttg_app_mobile/features/workout/application/workout_state.dart';
import 'package:ttg_app_mobile/features/workout/data/workout_api_service.dart';

final workoutApiProvider =
Provider<WorkoutApiService>((ref) => WorkoutApiService());

final workoutProvider =
StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
  final controller = WorkoutController(ref.read(workoutApiProvider));
  Future.microtask(() => controller.init());
  return controller;
});