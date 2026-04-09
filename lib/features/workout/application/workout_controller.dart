import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';
import '../domain/next_session_suggestion.dart';
import '../domain/training_plan.dart';
import '../domain/set_log.dart';
import 'workout_state.dart';
import 'progression_engine.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();

  final Map<String, Timer> _debounceTimers = {};

  WorkoutController(this.api) : super(WorkoutState());

  Future<void> init() async => loadActiveWorkout();

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

  void updateSet({
    required String exerciseId,
    required String setId,
    double? weight,
    int? reps,
    bool? completed,
  }) {
    final session = state.session;
    if (session == null) return;

    final updatedExercises = session.exercises.map((e) {
      if (e.id != exerciseId) return e;

      final updatedSets = e.sets.map((s) {
        if (s.id != setId) return s;

        return s.copyWith(
          weight: weight,
          reps: reps,
          completed: completed,
        );
      }).toList();

      return e.copyWith(sets: updatedSets);
    }).toList();

    state = state.copyWith(
      session: session.copyWith(exercises: updatedExercises),
    );

    _debounceSave(exerciseId, setId);
  }

  void _debounceSave(String exerciseId, String setId) {
    final key = '$exerciseId-$setId';
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] =
        Timer(const Duration(milliseconds: 600), () => _syncSet(exerciseId, setId));
  }

  Future<void> _syncSet(String exerciseId, String setId) async {
    final session = state.session;
    if (session == null) return;

    final exercise =
    session.exercises.firstWhere((e) => e.id == exerciseId);

    final set = exercise.sets.firstWhere((s) => s.id == setId);

    try {
      await api.updateSet(
        exerciseId,
        set.id,
        set.reps,
        set.weight,
        set.completed,
      );
    } catch (_) {
      _retry(exerciseId, setId);
    }
  }

  void _retry(String exerciseId, String setId) {
    Timer(const Duration(seconds: 2), () => _syncSet(exerciseId, setId));
  }

  Future<void> reorderExercises(List<ExerciseSession> updated) async {
    final session = state.session;
    if (session == null) return;

    state = state.copyWith(
      session: session.copyWith(exercises: updated),
    );

    await api.reorderExercises(
      updated
          .map((e) => {
        'id': e.id,
        'order': e.order,
      })
          .toList(),
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
      final s = getSuggestion(e);
      return NextSessionSuggestion(
        exerciseName: e.name,
        weight: s?.suggestedWeight ?? 0,
        reps: s?.suggestedReps ?? 0,
        reason: s?.reason ?? 'none',
      );
    }).toList();
  }

  TrainingPlan buildPlanFromSuggestions() {
    final suggestions = buildNextSessionSuggestions();

    return TrainingPlan(
      exercises: suggestions
          .map((s) => PlannedExercise(
        name: s.exerciseName,
        reps: s.reps,
        weight: s.weight,
      ))
          .toList(),
    );
  }

  Future<void> startWorkoutFromPlan() async {
    final plan = buildPlanFromSuggestions();

    final exercises = plan.exercises.asMap().entries.map((e) {
      final planned = e.value;

      return ExerciseSession(
        id: DateTime.now().toIso8601String() + e.key.toString(),
        name: planned.name,
        order: e.key,
        sets: List.generate(
          3,
              (i) => SetLog(
            id: '${DateTime.now().millisecondsSinceEpoch}$i',
            weight: planned.weight,
            reps: planned.reps,
          ),
        ),
      );
    }).toList();

    state = state.copyWith(
      session: WorkoutSession(
        id: DateTime.now().toIso8601String(),
        startedAt: DateTime.now(),
        exercises: exercises,
      ),
    );
  }

  Future<List<WorkoutHistoryEntry>> loadHistory(String exerciseId) async {
    final raw = await api.getHistory(exerciseId);

    return raw
        .map((e) => WorkoutHistoryEntry(
      weight: (e['weight'] as num).toDouble(),
      reps: e['reps'],
      date: DateTime.parse(e['date']),
    ))
        .toList();
  }
}