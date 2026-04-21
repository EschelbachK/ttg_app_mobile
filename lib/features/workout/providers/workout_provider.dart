import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../application/workout_controller.dart';
import '../application/workout_state.dart';
import '../data/workout_api_service.dart';

final workoutProvider =
StateNotifierProvider<WorkoutController, WorkoutState>(
      (ref) => WorkoutController(
    WorkoutApiService(ref.read(dioProvider)),
    ref,
  ),
);