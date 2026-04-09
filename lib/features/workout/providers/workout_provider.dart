import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/dio_provider.dart';
import '../application/workout_controller.dart';
import '../application/workout_state.dart';
import '../data/workout_api_service.dart';
import '../providers/motivation_provider.dart';

final workoutProvider =
StateNotifierProvider<WorkoutController, WorkoutState>((ref) {
  return WorkoutController(
    WorkoutApiService(
      ApiClient(ref.read(dioProvider)),
    ),
    ref.read(motivationProvider.notifier),
    ref,
  );
});