import '../domain/motivation/motivation_message_builder.dart';
import '../domain/motivation/motivation_rules.dart';
import '../domain/workout_session.dart';
import '../domain/streak_tracker.dart';
import '../domain/motivation/motivation_event.dart';
import '../domain/motivation/motivation_result.dart';
import '../domain/motivation/motivation_type.dart';
import '../domain/motivation/motivation_level.dart';

class MotivationEngine {
  final StreakTracker streak = StreakTracker();

  void updateStreak(WorkoutSession session) {
    streak.update(session.startedAt);
  }

  MotivationResult evaluate(MotivationEvent event) {
    final reps = event.repsDiff ?? 0;
    final weight = event.weightDiff ?? 0;

    final isProgress = reps > 0 || weight > 0;
    final hasStreak = event.streakDays > 0;

    final progressLevel =
    isProgress ? MotivationRules.prLevel(reps, weight) : null;

    final streakLevel =
    hasStreak ? MotivationRules.streakLevel(event.streakDays) : null;

    if (isProgress && hasStreak) {
      final combined =
          MotivationRules.priority(progressLevel!) +
              MotivationRules.priority(streakLevel!);

      final level = combined >= 7
          ? MotivationLevel.extreme
          : combined >= 5
          ? MotivationLevel.high
          : MotivationLevel.medium;

      return MotivationResult(
        type: MotivationType.pr,
        level: level,
        message: _comboMessage(level),
      );
    }

    if (event.isComeback) {
      return MotivationResult(
        type: MotivationType.comeback,
        level: MotivationLevel.high,
        message: MotivationMessageBuilder.build(
          MotivationType.comeback,
          MotivationLevel.high,
        ),
      );
    }

    if (event.totalWorkouts > 0 && event.totalWorkouts % 10 == 0) {
      final level = event.totalWorkouts >= 50
          ? MotivationLevel.extreme
          : event.totalWorkouts >= 25
          ? MotivationLevel.high
          : MotivationLevel.medium;

      return MotivationResult(
        type: MotivationType.milestone,
        level: level,
        message: MotivationMessageBuilder.build(
          MotivationType.milestone,
          level,
        ),
      );
    }

    if (isProgress && progressLevel != null) {
      return MotivationResult(
        type: MotivationType.pr,
        level: progressLevel,
        message: MotivationMessageBuilder.build(
          MotivationType.pr,
          progressLevel,
        ),
      );
    }

    if (hasStreak && streakLevel != null) {
      return MotivationResult(
        type: MotivationType.streak,
        level: streakLevel,
        message: MotivationMessageBuilder.build(
          MotivationType.streak,
          streakLevel,
        ),
      );
    }

    return MotivationResult(
      type: MotivationType.neutral,
      level: MotivationLevel.low,
      message: MotivationMessageBuilder.build(
        MotivationType.neutral,
        MotivationLevel.low,
      ),
    );
  }

  String _comboMessage(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚨 Serie läuft! Und du erreichst neue Levels!";
      case MotivationLevel.high:
        return "⚡ Serie läuft! Heute richtig stark!";
      case MotivationLevel.medium:
        return "Gute Serie! Bleib dran!";
      case MotivationLevel.low:
        return "Weiter!";
    }
  }
}