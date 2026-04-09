import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/workout_controller.dart';
import '../application/workout_state.dart';
import '../data/workout_api_service.dart';

final workoutApiProvider = Provider((ref) => WorkoutApiService());

final workoutProvider =
StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
  return WorkoutController(ref.read(workoutApiProvider));
});