import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';
import '../domain/next_session_suggestion.dart';
import '../domain/workout_training_plan.dart';
import '../domain/set_log.dart';
import 'workout_state.dart';
import 'progression_engine.dart';
import 'motivation_engine.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();
  final MotivationEngine motivator = MotivationEngine();
  final Map<String, Timer> _debounceTimers = {};

  WorkoutController(this.api) : super(const WorkoutState());

  Future<void> init() async => loadActiveWorkout();

  Future<void> loadActiveWorkout() async {
    state = state.copyWith(isLoading: true);
    try {
      final session = await api.getActiveWorkout();
      state = state.copyWith(session: session, isLoading: false);
      if (session != null) motivator.updateStreak(session);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> startWorkout() async {
    try {
      await api.startWorkout();
      await loadActiveWorkout();
    } catch (_) {}
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    final s = state.session;
    if (s == null) return;
    final newSet = SetLog(id: DateTime.now().toIso8601String(), weight: weight, reps: reps);
    final updatedExercises = s.exercises.map((e) {
      if (e.id != exerciseId) return e;
      return e.copyWith(sets: [...e.sets, newSet]);
    }).toList();
    state = state.copyWith(session: s.copyWith(exercises: updatedExercises));
    try {
      await api.addSet(exerciseId, weight, reps);
    } catch (_) {}
    motivator.checkPRs(exerciseId, updatedExercises);
  }

  void updateSet({required String exerciseId, required String setId, double? weight, int? reps, bool? completed}) {
    final s = state.session;
    if (s == null) return;
    final updatedExercises = s.exercises.map((e) {
      if (e.id != exerciseId) return e;
      return e.copyWith(
        sets: e.sets.map((set) {
          if (set.id != setId) return set;
          return set.copyWith(weight: weight, reps: reps, completed: completed);
        }).toList(),
      );
    }).toList();
    state = state.copyWith(session: s.copyWith(exercises: updatedExercises));
    _debounceSave(exerciseId, setId);
  }

  void _debounceSave(String exerciseId, String setId) {
    final key = '$exerciseId-$setId';
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(const Duration(milliseconds: 600), () => _syncSet(exerciseId, setId));
  }

  Future<void> _syncSet(String exerciseId, String setId) async {
    final s = state.session;
    if (s == null) return;
    final ex = s.exercises.firstWhere((e) => e.id == exerciseId);
    final set = ex.sets.firstWhere((s) => s.id == setId);
    try {
      await api.updateSet(exerciseId, set.id, set.reps, set.weight, set.completed);
    } catch (_) {
      Timer(const Duration(seconds: 2), () => _syncSet(exerciseId, setId));
    }
  }

  Future<void> reorderExercises(List<ExerciseSession> updated) async {
    final s = state.session;
    if (s == null) return;
    state = state.copyWith(session: s.copyWith(exercises: updated));
    try {
      await api.reorderExercises(updated.map((e) => {'id': e.id, 'order': e.order}).toList());
    } catch (_) {}
  }

  ProgressionResult? getSuggestion(ExerciseSession exercise) {
    if (exercise.sets.isEmpty) return null;
    final last = exercise.sets.last;
    final history = exercise.sets.map((s) => WorkoutHistoryEntry(weight: s.weight, reps: s.reps, date: DateTime.now())).toList();
    return engine.calculate(ProgressionInput(lastWeight: last.weight, lastReps: last.reps, targetReps: last.reps, history: history));
  }

  List<NextSessionSuggestion> buildNextSessionSuggestions() {
    final s = state.session;
    if (s == null) return [];
    return s.exercises.map((e) {
      final sug = getSuggestion(e);
      return NextSessionSuggestion(
        exerciseName: e.name,
        weight: sug?.weight ?? 0,
        reps: sug?.reps ?? 0,
        reason: sug?.reason ?? 'none',
      );
    }).toList();
  }

  TrainingPlan buildPlanFromSuggestions() {
    final suggestions = buildNextSessionSuggestions();
    return TrainingPlan(
      name: 'Suggested Plan',
      exercises: suggestions.map((s) => PlannedExercise(name: s.exerciseName, reps: s.reps, weight: s.weight)).toList(),
    );
  }

  Future<void> startWorkoutFromPlan() async {
    final plan = buildPlanFromSuggestions();
    final exercises = plan.exercises.asMap().entries.map((e) {
      final p = e.value;
      return ExerciseSession(
        id: DateTime.now().toIso8601String() + e.key.toString(),
        name: p.name,
        order: e.key,
        sets: List.generate(3, (i) => SetLog(id: '${DateTime.now().millisecondsSinceEpoch}$i', weight: p.weight, reps: p.reps)),
      );
    }).toList();
    state = state.copyWith(session: WorkoutSession(id: DateTime.now().toIso8601String(), startedAt: DateTime.now(), exercises: exercises));
  }

  Future<List<WorkoutHistoryEntry>> loadHistory(String exerciseId) async {
    try {
      final raw = await api.getHistory(exerciseId);
      return raw.map((e) => WorkoutHistoryEntry(weight: (e['weight'] as num).toDouble(), reps: e['reps'], date: DateTime.parse(e['date']))).toList();
    } catch (_) {
      return [];
    }
  }
}