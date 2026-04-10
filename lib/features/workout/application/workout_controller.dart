import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/workout_group.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';
import '../domain/next_session_suggestion.dart';
import '../domain/set_log.dart';
import '../providers/motivation_provider.dart';
import 'workout_state.dart';
import 'progression_engine.dart';
import 'motivation_event_builder.dart';
import 'workout_mapper.dart';
import '../../dashboard/state/dashboard_provider.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();
  final MotivationNotifier motivator;
  final Ref ref;

  final Map<String, Timer> _debounceTimers = {};

  WorkoutController(this.api, this.motivator, this.ref)
      : super(const WorkoutState());

  Future<void> init() async => loadActiveWorkout();

  Future<void> loadActiveWorkout() async {
    state = state.copyWith(isLoading: true);
    try {
      final session = await api.getActiveWorkout();
      state = state.copyWith(session: session, isLoading: false);
      if (session != null) motivator.updateStreakFromSession(session);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> startWorkout() async {
    try {
      await api.startWorkout();
      final session = await api.getActiveWorkout();
      state = state.copyWith(session: session ?? _fallback());
    } catch (_) {
      state = state.copyWith(session: _fallback());
    }
  }

  WorkoutSession _fallback() {
    return WorkoutSession(
      id: DateTime.now().toIso8601String(),
      startedAt: DateTime.now(),
      groups: [
        WorkoutGroup(
          name: 'Default',
          order: 0,
          exercises: [
            ExerciseSession(
              id: DateTime.now().toIso8601String(),
              name: 'Exercise',
              order: 0,
              sets: [
                SetLog(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  weight: 0,
                  reps: 0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> startWorkoutFromPlan(TrainingPlan plan) async {
    final dashboard = ref.read(dashboardProvider);

    state = state.copyWith(
      session: WorkoutSession(
        id: DateTime.now().toIso8601String(),
        startedAt: DateTime.now(),
        groups: WorkoutMapper.fromPlan(
          plan: plan,
          folders: dashboard.folders,
        ),
      ),
    );
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    final s = state.session;
    if (s == null) return;

    final newSet = SetLog(
      id: DateTime.now().toIso8601String(),
      weight: weight,
      reps: reps,
    );

    final groups = s.groups.map((g) {
      return g.copyWith(
        exercises: g.exercises.map((e) {
          if (e.id != exerciseId) return e;
          return e.copyWith(sets: [...e.sets, newSet]);
        }).toList(),
      );
    }).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));

    try {
      await api.addSet(exerciseId, weight, reps);
    } catch (_) {}

    _runMotivation(exerciseId);
  }

  void updateSet({
    required String exerciseId,
    required String setId,
    double? weight,
    int? reps,
    bool? completed,
  }) {
    final s = state.session;
    if (s == null) return;

    final groups = s.groups.map((g) {
      return g.copyWith(
        exercises: g.exercises.map((e) {
          if (e.id != exerciseId) return e;
          return e.copyWith(
            sets: e.sets.map((set) {
              if (set.id != setId) return set;
              return set.copyWith(
                weight: weight,
                reps: reps,
                completed: completed,
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));

    _debounceSave(exerciseId, setId);
    _runMotivation(exerciseId);
  }

  void deleteSet(String exerciseId, String setId) {
    final s = state.session;
    if (s == null) return;

    final groups = s.groups.map((g) {
      return g.copyWith(
        exercises: g.exercises.map((e) {
          if (e.id != exerciseId) return e;
          return e.copyWith(
            sets: e.sets.where((s) => s.id != setId).toList(),
          );
        }).toList(),
      );
    }).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));

    try {
      api.deleteSet(exerciseId, setId);
    } catch (_) {}
  }

  void _debounceSave(String exerciseId, String setId) {
    final key = '$exerciseId-$setId';
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(
      const Duration(milliseconds: 500),
          () => _syncSet(exerciseId, setId),
    );
  }

  Future<void> _syncSet(String exerciseId, String setId) async {
    final s = state.session;
    if (s == null) return;

    final ex = s.groups.expand((g) => g.exercises)
        .firstWhere((e) => e.id == exerciseId);

    final set = ex.sets.firstWhere((s) => s.id == setId);

    try {
      await api.updateSet(
        exerciseId,
        set.id,
        set.reps,
        set.weight,
        set.completed,
      );
    } catch (_) {
      Timer(const Duration(seconds: 2),
              () => _syncSet(exerciseId, setId));
    }
  }

  Future<void> finishWorkout() async {
    final s = state.session;
    if (s == null) return;

    try {
      await api.finishWorkout(s);
      state = state.copyWith(isFinished: true);
    } catch (_) {}
  }

  void _runMotivation(String exerciseId) {
    final s = state.session;
    if (s == null) return;

    final exercise = s.groups
        .expand((g) => g.exercises)
        .firstWhere((e) => e.id == exerciseId);

    final event = MotivationEventBuilder.fromExercise(exercise: exercise);

    motivator.evaluate(
      event.copyWith(
        streakDays: motivator.engine.streak.streakCount,
      ),
    );
  }

  ProgressionResult? getSuggestion(ExerciseSession e) {
    if (e.sets.isEmpty) return null;

    final last = e.sets.last;

    return engine.calculate(
      ProgressionInput(
        lastWeight: last.weight,
        lastReps: last.reps,
        targetReps: last.reps,
        history: e.sets.map((s) {
          return WorkoutHistoryEntry(
            weight: s.weight,
            reps: s.reps,
            date: DateTime.now(),
          );
        }).toList(),
      ),
    );
  }

  List<NextSessionSuggestion> buildNextSessionSuggestions() {
    final s = state.session;
    if (s == null) return [];

    return s.groups.expand((g) => g.exercises).map((e) {
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
    return WorkoutMapper.fromSuggestions(suggestions);
  }
}