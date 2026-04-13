import '../domain/workout_session.dart';
import '../domain/streak_tracker.dart';
import '../domain/motivation/motivation_event.dart';
import '../domain/motivation/motivation_result.dart';
import '../domain/motivation/motivation_type.dart';
import '../domain/motivation/motivation_level.dart';
import '../domain/motivation/motivation_message_builder.dart';
import '../domain/motivation/motivation_rules.dart';

class MotivationEngine {
  final StreakTracker streak = StreakTracker();

  void updateStreak(WorkoutSession session) {
    streak.update(session.startedAt);
  }

  MotivationResult evaluate(MotivationEvent event) {
    final hasProgress = event.hasProgress;
    final hasStreak = event.streakDays > 0;

    final progressLevel = hasProgress
        ? MotivationRules.prLevel(
      event.repsDiff ?? 0,
      event.weightDiff ?? 0,
    )
        : null;

    final streakLevel = hasStreak
        ? MotivationRules.streakLevel(event.streakDays)
        : null;

    if (hasProgress && hasStreak) {
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
        message: "🔥 Progress + Streak kombiniert!",
      );
    }

    if (hasProgress) {
      return MotivationResult(
        type: MotivationType.pr,
        level: progressLevel!,
        message: MotivationMessageBuilder.build(
            MotivationType.pr, progressLevel),
      );
    }

    if (hasStreak) {
      return MotivationResult(
        type: MotivationType.streak,
        level: streakLevel!,
        message: MotivationMessageBuilder.build(
            MotivationType.streak, streakLevel),
      );
    }

    return MotivationResult(
      type: MotivationType.neutral,
      level: MotivationLevel.low,
      message: MotivationMessageBuilder.build(
          MotivationType.neutral, MotivationLevel.low),
    );
  }
}