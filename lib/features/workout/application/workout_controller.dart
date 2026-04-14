import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import 'package:ttg_app_mobile/features/workout/application/rest_timer.dart';
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
import 'workout_flow/workout_flow_handler.dart';
import 'factories/workout_session_factory.dart';
import 'updaters/workout_session_updater.dart';

class WorkoutController extends StateNotifier<WorkoutState> {
  final WorkoutApiService api;
  final ProgressionEngine engine = ProgressionEngine();
  final MotivationNotifier motivator;
  final Ref ref;

  final RestTimer _rest = RestTimer();
  final WorkoutFlowHandler _flow = WorkoutFlowHandler();

  int _restSeconds = 0;
  bool _showRest = false;

  int get restSeconds => _restSeconds;
  bool get showRest => _showRest;

  WorkoutController(this.api, this.motivator, this.ref)
      : super(const WorkoutState());

  void _emit() => state = state.copyWith();

  void reset() {
    _rest.stop();
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

  void startRestTimer(int seconds, {String? message}) {
    state = state.copyWith(
      restMessage: message,
      clearRestMessage: false,
    );

    _showRest = true;

    _rest.start(
      seconds: seconds,
      onTick: (sec) {
        _restSeconds = sec;
        _emit();
      },
      onDone: () {
        _restSeconds = 0;
        _showRest = false;
        state = state.copyWith(clearRestMessage: true);
        _emit();
      },
    );

    _emit();
  }

  void stopRestTimer() {
    _rest.stop();

    _restSeconds = 0;
    _showRest = false;

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
        groups: WorkoutMapper.fromPlan(
          plan: plan,
          folders: dash.folders,
        ),
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

    final groups = s.groups
        .map((g) => g.copyWith(
      exercises: g.exercises
          .map((e) => e.id == exerciseId
          ? e.copyWith(sets: [...e.sets, set])
          : e)
          .toList(),
    ))
        .toList();

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

    final updated = _applySetUpdate(
      s,
      exerciseId,
      setId,
      weight,
      reps,
      completed,
    );

    state = state.copyWith(session: updated);

    state = _flow.evaluateSetCompletion(
      state: state,
      before: s,
      after: updated,
      exerciseId: exerciseId,
      onSetFocus: (id) {
        state = state.copyWith(activeExerciseId: id);
      },
      startRestTimer: (seconds, message) {
        startRestTimer(seconds, message: message);
      },
      triggerFinishFlow: () {
        state = state.copyWith(triggerFinishFlow: true);
      },
    );

    if (completed == true) {
      state = state.copyWith(activeExerciseId: exerciseId);
      startRestTimer(60);
    }
  }

  WorkoutSession _applySetUpdate(
      WorkoutSession s,
      String exerciseId,
      String setId,
      double? weight,
      int? reps,
      bool? completed,
      ) {
    return WorkoutSessionUpdater.updateSet(
      session: s,
      exerciseId: exerciseId,
      setId: setId,
      weight: weight,
      reps: reps,
      completed: completed,
    );
  }

  WorkoutSession _fallback() {
    return WorkoutSessionFactory.createFallback();
  }
}