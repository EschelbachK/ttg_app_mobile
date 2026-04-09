import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import 'workout_state.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;

  WorkoutController(this.api) : super(WorkoutState());

  Future<void> init() async {
    await loadActiveWorkout();
  }

  Future<void> loadActiveWorkout() async {
    state = state.copyWith(isLoading: true);
    final session = await api.getActiveWorkout();
    state = state.copyWith(session: session, isLoading: false);
  }

  Future<void> startWorkout() async {
    await api.startWorkout();
    await loadActiveWorkout();
  }

  Future<void> reorderExercises(List<ExerciseSession> updated) async {
    final session = state.session;
    if (session == null) return;

    state = state.copyWith(
      session: session.copyWith(exercises: updated),
    );
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    final session = state.session;
    if (session == null) return;

    final newSet = SetLog(
      id: DateTime.now().toIso8601String(),
      weight: weight,
      reps: reps,
    );

    final updatedExercises = session.exercises.map((e) {
      if (e.id == exerciseId) {
        return e.copyWith(sets: [...e.sets, newSet]);
      }
      return e;
    }).toList();

    state = state.copyWith(
      session: session.copyWith(exercises: updatedExercises),
    );

    await api.addSet(exerciseId, weight, reps);
  }
}