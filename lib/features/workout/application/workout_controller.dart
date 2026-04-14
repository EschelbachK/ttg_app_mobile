// DEIN CODE 1:1 BEIBEHALTEN (nur RestMessage Fix integriert)

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/workout_group.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';
import '../domain/set_log.dart';
import '../domain/motivation/motivation_event.dart';
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
  bool _showRest = false;

  int get restSeconds => _restSeconds;
  bool get showRest => _showRest;

  WorkoutController(this.api, this.motivator, this.ref)
      : super(const WorkoutState());

  void _emit() => state = state.copyWith();

  void reset() {
    _restTimer?.cancel();
    _restSeconds = 0;
    _showRest = false;
    state = const WorkoutState();
  }

  ProgressionResult? getSuggestion(ExerciseSession e) {
    if (e.sets.isEmpty) return null;
    final last = e.sets.last;
    return engine.calculate(
      ProgressionInput(
        lastWeight: last.weight,
        lastReps: last.reps,
        targetReps: last.reps,
        history: e.sets.map((s) => WorkoutHistoryEntry(
          weight: s.weight,
          reps: s.reps,
          date: DateTime.now(),
        )).toList(),
      ),
    );
  }

  void startRestTimer(int seconds, {String? message}) {
    _restTimer?.cancel();
    _restSeconds = seconds;
    _showRest = true;

    // ✅ FIX: Message korrekt setzen
    state = state.copyWith(
      restMessage: message,
      clearRestMessage: false,
    );
    _emit();

    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_restSeconds-- <= 0) {
        t.cancel();
        _restSeconds = 0;
        _showRest = false;

        // ✅ FIX: Message wirklich löschen
        state = state.copyWith(clearRestMessage: true);
      }
      _emit();
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    _restSeconds = 0;
    _showRest = false;

    // ✅ FIX: Message wirklich löschen
    state = state.copyWith(clearRestMessage: true);
    _emit();
  }

  Future<void> startWorkout() async {
    if (state.session != null && !state.isFinished) return;
    try {
      await api.startWorkout();
      final s = await api.getActiveWorkout();
      state = state.copyWith(
        session: s ?? _fallback(),
        isPaused: false,
        isFinished: false,
        triggerFinishFlow: false,
      );
    } catch (_) {
      state = state.copyWith(
        session: _fallback(),
        isPaused: false,
        isFinished: false,
        triggerFinishFlow: false,
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
        groups: WorkoutMapper.fromPlan(plan: plan, folders: dash.folders),
      ),
      isFinished: false,
      isPaused: false,
      triggerFinishFlow: false,
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

    final updated =
    WorkoutMapper.fromPlan(plan: plan, folders: dash.folders);

    final merged = updated.map((g) {
      final existing = s.groups.firstWhere(
            (e) => e.name == g.name,
        orElse: () => g,
      );

      return g.copyWith(
        exercises: g.exercises.map((ex) {
          final old = existing.exercises.firstWhere(
                (e) => e.name == ex.name,
            orElse: () => ex,
          );
          return ex.copyWith(sets: old.sets);
        }).toList(),
      );
    }).toList();

    state = state.copyWith(
      session: s.copyWith(groups: merged),
      isPaused: false,
      isFinished: false,
    );
  }

  Future<void> addSet(String exerciseId, double weight, int reps) async {
    final s = state.session;
    if (s == null) return;

    final set = SetLog(
      id: DateTime.now().toIso8601String(),
      weight: weight,
      reps: reps,
    );

    final groups = s.groups.map((g) => g.copyWith(
      exercises: g.exercises.map((e) =>
      e.id == exerciseId ? e.copyWith(sets: [...e.sets, set]) : e).toList(),
    )).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));

    try {
      await api.addSet(exerciseId, weight, reps);
    } catch (_) {}
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
      final prev =
      history.length > 1 ? history[history.length - 2] : null;

      motivator.evaluate(MotivationEvent(
        repsDiff: prev != null ? last.reps - prev.reps : 0,
        weightDiff: prev != null ? last.weight - prev.weight : 0,
        streakDays: motivator.engine.streak.streakCount,
        isComeback: motivator.engine.streak.streakCount == 1,
        totalWorkouts: history.length,
      ));

      motivator.updateStreakFromSession(s);
    }

    state = state.copyWith(isFinished: true, isPaused: false);
  }

  void pauseWorkout() {
    state = state.copyWith(isPaused: true);
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

    final groupBefore = s.groups.firstWhere(
          (g) => g.exercises.any((e) => e.id == exerciseId),
    );

    final setsBefore = groupBefore.exercises.expand((e) => e.sets);
    final remainingBefore =
        setsBefore.where((x) => x.completed != true).length;

    final updated = s.copyWith(
      groups: s.groups.map((g) => g.copyWith(
        exercises: g.exercises.map((e) {
          if (e.id != exerciseId) return e;
          return e.copyWith(
            sets: e.sets.map((x) => x.id == setId
                ? x.copyWith(
              weight: weight ?? x.weight,
              reps: reps ?? x.reps,
              completed: completed ?? x.completed,
            )
                : x).toList(),
          );
        }).toList(),
      )).toList(),
    );

    state = state.copyWith(session: updated);

    final groupAfter = updated.groups.firstWhere(
          (g) => g.exercises.any((e) => e.id == exerciseId),
    );

    final setsAfter = groupAfter.exercises.expand((e) => e.sets);
    final remainingAfter =
        setsAfter.where((x) => x.completed != true).length;

    final groupIndex = updated.groups.indexOf(groupAfter);
    final isLastGroup = groupIndex == updated.groups.length - 1;

    final justFinishedGroup =
        remainingBefore > 0 && remainingAfter == 0;

    if (justFinishedGroup) {
      if (isLastGroup) {
        state = state.copyWith(triggerFinishFlow: true);
        return;
      }

      final next = updated.groups[groupIndex + 1];

      startRestTimer(
        60,
        message:
        '🔥 ${groupAfter.name} abgeschlossen\n➡️ Nächste: ${next.name}',
      );
      return;
    }

    if (completed == true) {
      startRestTimer(60);
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
}