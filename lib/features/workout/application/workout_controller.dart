import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';

import '../../../core/events/event_bus_provider.dart';
import '../../../core/events/workout_events.dart';
import '../../../core/haptics/haptic_provider.dart';
import '../../history/application/history_service.dart';
import '../data/workout_api_service.dart';
import '../domain/workout_session.dart';
import '../domain/set_log.dart';
import '../domain/progression_input.dart';
import '../domain/progression_result.dart';
import '../domain/workout_history_entry.dart';
import 'workout_state.dart';
import 'progression_engine.dart';
import 'workout_mapper.dart';
import '../../dashboard/state/dashboard_provider.dart';
import '../../settings/application/settings_provider.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();
  final Ref ref;

  late final HistoryService historyService;

  Timer? _restTimer;
  int _restSeconds = 0;

  int get restSeconds => _restSeconds;
  bool get showRest => _restSeconds > 0;
  bool get _offline => ref.read(settingsProvider).offlineMode;

  WorkoutController(this.api, this.ref) : super(const WorkoutState()) {
    historyService = ref.read(historyServiceProvider);
  }

  void _emit() => state = state.copyWith();

  void reset() {
    _restTimer?.cancel();
    _restSeconds = 0;
    state = const WorkoutState();
  }

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
      if (!_offline) await api.startWorkout();
      final s = !_offline ? await api.getActiveWorkout() : null;

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
      if (!_offline) await api.finishWorkout(s);
    } catch (_) {}

    historyService.saveSession(s);

    ref.read(eventBusProvider).emit(
      WorkoutFinishedEvent(s),
    );

    ref.read(hapticProvider).success();

    state = state.copyWith(isFinished: true);
  }

  void pauseWorkout() {
    state = state.copyWith(isPaused: true);
  }

  void startRestTimer(int seconds, {String? message}) {
    _restTimer?.cancel();
    _restSeconds = seconds;

    final bus = ref.read(eventBusProvider);

    state = state.copyWith(restMessage: message);

    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _restSeconds--;

      bus.emit(TimerTickEvent(_restSeconds));

      if (_restSeconds <= 0) {
        t.cancel();
        _restSeconds = 0;

        bus.emit(RestFinishedEvent());
        ref.read(hapticProvider).medium();

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

    ref.read(eventBusProvider).emit(
      SetCompletedEvent(exerciseId: exerciseId, set: set),
    );

    ref.read(hapticProvider).light();
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

    bool didCompleteSet = false;
    bool isFinalWorkout = true;
    String? completedGroup;
    String? nextGroup;

    final updatedGroups = s.groups.map((g) {
      final beforeComplete = g.exercises.every(
            (e) => e.sets.isNotEmpty && e.sets.every((x) => x.completed == true),
      );

      final exercises = g.exercises.map((e) {
        if (e.id != exerciseId) return e;

        return e.copyWith(
          sets: e.sets.map((x) {
            if (x.id == setId && completed == true && x.completed != true) {
              didCompleteSet = true;
            }

            return x.id == setId
                ? x.copyWith(
              weight: weight ?? x.weight,
              reps: reps ?? x.reps,
              completed: completed ?? x.completed,
            )
                : x;
          }).toList(),
        );
      }).toList();

      final afterComplete = exercises.every(
            (e) => e.sets.isNotEmpty && e.sets.every((x) => x.completed == true),
      );

      if (!beforeComplete && afterComplete) {
        completedGroup = g.name;
      }

      if (!afterComplete) isFinalWorkout = false;

      return g.copyWith(exercises: exercises);
    }).toList();

    final updated = s.copyWith(groups: updatedGroups);
    state = state.copyWith(session: updated);

    if (completedGroup != null) {
      final i = updatedGroups.indexWhere((g) => g.name == completedGroup);
      if (i != -1 && i + 1 < updatedGroups.length) {
        nextGroup = updatedGroups[i + 1].name;
      }
    }

    if (!didCompleteSet) return;

    ref.read(hapticProvider).medium();

    if (isFinalWorkout) {
      finishWorkout();
      return;
    }

    final rest = ref.read(settingsProvider).restTimerSeconds;

    if (completedGroup != null) {
      ref.read(hapticProvider).heavy();

      startRestTimer(
        rest,
        message:
        "🔥 $completedGroup abgeschlossen ➜ Nächste: ${nextGroup ?? 'Fertig'}",
      );
    } else {
      startRestTimer(rest);
    }
  }

  WorkoutSession _fallback() {
    return WorkoutSession(
      id: DateTime.now().toIso8601String(),
      startedAt: DateTime.now(),
      groups: [],
    );
  }
}