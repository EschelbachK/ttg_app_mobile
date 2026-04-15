import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';

import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/workout_group.dart';
import '../domain/set_log.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/motivation/motivation_event.dart';
import '../domain/workout_history_entry.dart';

import '../providers/motivation_provider.dart';
import 'workout_state.dart';
import 'progression_engine.dart';
import 'workout_mapper.dart';
import 'workout_summary_mapper.dart';
import '../../dashboard/state/dashboard_provider.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();
  final MotivationNotifier motivator;
  final Ref ref;

  Timer? _restTimer;
  int _restSeconds = 0;

  int get restSeconds => _restSeconds;
  bool get showRest => _restSeconds > 0;

  WorkoutController(this.api, this.motivator, this.ref)
      : super(const WorkoutState());

  void _emit() => state = state.copyWith();

  void reset() {
    _restTimer?.cancel();
    _restSeconds = 0;
    state = const WorkoutState();
  }

  // ---------------- FIXED SUGGESTION ----------------
  ProgressionResult? getSuggestion(dynamic exercise) {
    final sets = exercise.sets as List<SetLog>;

    if (sets.isEmpty) return null;

    final last = sets.last;

    final history = sets
        .map((s) => WorkoutHistoryEntry(
      id: s.id,
      exerciseName: exercise.name ?? 'exercise',
      weight: s.weight,
      reps: s.reps,
      date: DateTime.now(),
      sessionId: state.session?.id ?? '',
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

  Future<void> startWorkout() async {
    if (state.session != null && !state.isFinished) return;

    try {
      await api.startWorkout();
      final s = await api.getActiveWorkout();

      state = state.copyWith(
        session: s ?? _fallback(),
        isFinished: false,
        isPaused: false,
      );
    } catch (_) {
      state = state.copyWith(
        session: _fallback(),
        isFinished: false,
        isPaused: false,
      );
    }
  }

  Future<void> startWorkoutFromPlan(TrainingPlan plan) async {
    if (state.session != null && !state.isFinished) return;

    final dash = ref.read(dashboardProvider);

    state = WorkoutState(
      session: WorkoutSession(
        id: DateTime.now().toIso8601String(),
        planId: plan.id,
        startedAt: DateTime.now(),
        groups: WorkoutMapper.fromPlan(
          plan: plan,
          folders: dash.folders,
        ),
      ),
      isFinished: false,
      isPaused: false,
    );
  }

  Future<void> resumeWorkoutWithLatestPlan() async {
    final s = state.session;
    if (s == null) return;

    final dash = ref.read(dashboardProvider);

    final plan = dash.trainingPlans.firstWhere(
          (p) => p.id == s.planId,
      orElse: () => dash.trainingPlans.first,
    );

    final updated = WorkoutMapper.fromPlan(
      plan: plan,
      folders: dash.folders,
    );

    state = state.copyWith(
      session: s.copyWith(groups: updated),
      isPaused: false,
    );
  }

  Future<void> finishWorkout() async {
    final s = state.session;
    if (s == null) return;

    try {
      await api.finishWorkout(s);
    } catch (_) {}

    final history = WorkoutSummaryMapper.toHistory(s);

    if (history.isNotEmpty) {
      final last = history.last;
      final prev = history.length > 1 ? history[history.length - 2] : null;

      motivator.evaluate(MotivationEvent(
        repsDiff: prev != null ? last.reps - prev.reps : 0,
        weightDiff: prev != null ? last.weight - prev.weight : 0,
        streakDays: motivator.engine.streak.streakCount,
        isComeback: motivator.engine.streak.streakCount == 1,
        totalWorkouts: history.length,
      ));

      motivator.updateStreakFromSession(s);
    }

    state = state.copyWith(isFinished: true);
  }

  void pauseWorkout() {
    state = state.copyWith(isPaused: true);
  }

  void startRestTimer(int seconds, {String? message}) {
    _restTimer?.cancel();
    _restSeconds = seconds;

    state = state.copyWith(restMessage: message);

    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_restSeconds-- <= 0) {
        t.cancel();
        _restSeconds = 0;
        state = state.copyWith(restMessage: null);
      }
      _emit();
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    _restSeconds = 0;
    state = state.copyWith(restMessage: null);
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    final s = state.session;
    if (s == null) return;

    final set = SetLog(
      id: DateTime.now().toIso8601String(),
      weight: weight,
      reps: reps,
    );

    final groups = s.groups.map((g) {
      return g.copyWith(
        exercises: g.exercises.map((e) {
          return e.id == exerciseId
              ? e.copyWith(sets: [...e.sets, set])
              : e;
        }).toList(),
      );
    }).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));
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

    final updated = s.copyWith(
      groups: s.groups.map((g) {
        return g.copyWith(
          exercises: g.exercises.map((e) {
            if (e.id != exerciseId) return e;

            return e.copyWith(
              sets: e.sets.map((x) {
                return x.id == setId
                    ? x.copyWith(
                  weight: weight ?? x.weight,
                  reps: reps ?? x.reps,
                  completed: completed ?? x.completed,
                )
                    : x;
              }).toList(),
            );
          }).toList(),
        );
      }).toList(),
    );

    state = state.copyWith(session: updated);
  }

  WorkoutSession _fallback() {
    return WorkoutSession(
      id: DateTime.now().toIso8601String(),
      startedAt: DateTime.now(),
      groups: [],
    );
  }
}