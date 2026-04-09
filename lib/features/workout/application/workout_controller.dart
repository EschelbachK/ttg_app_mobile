import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';
import '../domain/next_session_suggestion.dart';
import 'workout_state.dart';
import 'progression_engine.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();

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

  Future<void> reorderExercises(List<ExerciseSession> updated) async {
    final session = state.session;
    if (session == null) return;

    state = state.copyWith(
      session: session.copyWith(exercises: updated),
    );
  }

  ProgressionResult? getSuggestion(ExerciseSession exercise) {
    if (exercise.sets.isEmpty) return null;

    final last = exercise.sets.last;

    final history = exercise.sets
        .map((s) => WorkoutHistoryEntry(
      weight: s.weight,
      reps: s.reps,
      date: DateTime.now(),
    ))
        .toList();

    return engine.calculate(
      ProgressionInput(
        lastWeight: last.weight,
        lastReps: last.reps,
        targetReps: last.reps,
        history: history,
      ),
    );
  }

  List<NextSessionSuggestion> buildNextSessionSuggestions() {
    final session = state.session;
    if (session == null) return [];

    return session.exercises.map((e) {
      final suggestion = getSuggestion(e);

      return NextSessionSuggestion(
        exerciseName: e.name,
        weight: suggestion?.suggestedWeight ?? 0,
        reps: suggestion?.suggestedReps ?? 0,
        reason: suggestion?.reason ?? 'none',
      );
    }).toList();
  }
}