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
import '../providers/motivation_provider.dart';
import 'workout_state.dart';
import 'progression_engine.dart';
import 'workout_mapper.dart';
import '../../dashboard/state/dashboard_provider.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();
  final MotivationNotifier motivator;
  final Ref ref;

  final Map<String, Timer> _debounceTimers = {};
  Timer? _restTimer;
  int _restSeconds = 0;
  bool _showRest = false;

  int get restSeconds => _restSeconds;
  bool get showRest => _showRest;

  WorkoutController(this.api, this.motivator, this.ref)
      : super(const WorkoutState());

  void _update() => state = state.copyWith();

  void startRestTimer(int seconds) {
    _restTimer?.cancel();
    _restSeconds = seconds;
    _showRest = true;
    _update();

    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_restSeconds <= 1) {
        t.cancel();
        _restSeconds = 0;
        _showRest = false;
      } else {
        _restSeconds--;
      }
      _update();
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    _restSeconds = 0;
    _showRest = false;
    _update();
  }

  Future<void> startWorkout() async {
    if (state.session != null && !state.isFinished) return;

    try {
      await api.startWorkout();
      final session = await api.getActiveWorkout();
      state = state.copyWith(
        session: session ?? _fallback(),
        isPaused: false,
        isFinished: false,
      );
    } catch (_) {
      state = state.copyWith(
        session: _fallback(),
        isPaused: false,
        isFinished: false,
      );
    }
  }

  Future<void> startWorkoutFromPlan(TrainingPlan plan) async {
    if (state.session != null && !state.isFinished) return;

    final dashboard = ref.read(dashboardProvider);

    state = WorkoutState(
      session: WorkoutSession(
        id: DateTime.now().toIso8601String(),
        planId: plan.id,
        startedAt: DateTime.now(),
        groups: WorkoutMapper.fromPlan(
          plan: plan,
          folders: dashboard.folders,
        ),
      ),
      isFinished: false,
      isPaused: false,
    );
  }

  Future<void> resumeWorkoutWithLatestPlan() async {
    final s = state.session;
    if (s == null) return;

    final dashboard = ref.read(dashboardProvider);

    final plan = dashboard.trainingPlans.firstWhere(
          (p) => p.id == s.planId,
      orElse: () => dashboard.trainingPlans.first,
    );

    final updated = WorkoutMapper.fromPlan(
      plan: plan,
      folders: dashboard.folders,
    );

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
      exercises: g.exercises.map((e) {
        if (e.id != exerciseId) return e;
        return e.copyWith(sets: [...e.sets, set]);
      }).toList(),
    )).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));

    try {
      await api.addSet(exerciseId, weight, reps);
    } catch (_) {}
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

    final groups = s.groups.map((g) => g.copyWith(
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
    )).toList();

    state = state.copyWith(session: s.copyWith(groups: groups));
  }

  ProgressionResult? getSuggestion(ExerciseSession e) {
    if (e.sets.isEmpty) return null;

    final last = e.sets.last;

    return engine.calculate(
      ProgressionInput(
        lastWeight: last.weight,
        lastReps: last.reps,
        targetReps: last.reps,
        history: e.sets
            .map((s) => WorkoutHistoryEntry(
          weight: s.weight,
          reps: s.reps,
          date: DateTime.now(),
        ))
            .toList(),
      ),
    );
  }

  Future<void> finishWorkout() async {
    final s = state.session;
    if (s == null) return;

    try {
      await api.finishWorkout(s);
    } catch (_) {}

    state = state.copyWith(
      isFinished: true,
      isPaused: false,
    );
  }

  void pauseWorkout() {
    if (state.session == null) return;
    state = state.copyWith(isPaused: true);
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