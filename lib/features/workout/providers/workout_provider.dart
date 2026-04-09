import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/workout_controller.dart';
import '../application/workout_state.dart';
import '../data/workout_api_service.dart';
import '../providers/motivation_provider.dart';

final workoutApiProvider =
Provider<WorkoutApiService>((ref) => ref.read(workoutApiServiceProvider));

final workoutProvider =
StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
  final api = ref.read(workoutApiProvider);
  final motivator = ref.read(motivationProvider.notifier);
  final controller = WorkoutController(api, motivator);
  Future.microtask(controller.init);
  return controller;
});