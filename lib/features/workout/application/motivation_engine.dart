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

    final isPR = reps > 0 || weight > 0;
    final hasStreak = event.streakDays > 0;

    final results = <MotivationResult>[];

    MotivationLevel? prLevel;
    MotivationLevel? streakLevel;

    if (isPR) {
      prLevel = MotivationRules.prLevel(reps, weight);
      results.add(MotivationResult(
        type: MotivationType.pr,
        level: prLevel,
        message: MotivationMessageBuilder.build(MotivationType.pr, prLevel),
      ));
    }

    if (hasStreak) {
      streakLevel = MotivationRules.streakLevel(event.streakDays);
      results.add(MotivationResult(
        type: MotivationType.streak,
        level: streakLevel,
        message: MotivationMessageBuilder.build(MotivationType.streak, streakLevel),
      ));
    }

    if (isPR && hasStreak) {
      final combinedScore =
          MotivationRules.priority(prLevel!) +
              MotivationRules.priority(streakLevel!);

      final MotivationLevel level;
      if (combinedScore >= 7) {
        level = MotivationLevel.extreme;
      } else if (combinedScore >= 5) {
        level = MotivationLevel.high;
      } else {
        level = MotivationLevel.medium;
      }

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

    if (results.isEmpty) {
      return MotivationResult(
        type: MotivationType.neutral,
        level: MotivationLevel.low,
        message: MotivationMessageBuilder.build(
          MotivationType.neutral,
          MotivationLevel.low,
        ),
      );
    }

    results.sort((a, b) =>
        MotivationRules.priority(b.level)
            .compareTo(MotivationRules.priority(a.level)));

    return results.first;
  }

  String _comboMessage(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚨 Streak läuft! Und du zerstörst PRs!";
      case MotivationLevel.high:
        return "⚡ Streak läuft! Heute stark!";
      case MotivationLevel.medium:
        return "Gute Serie! Bleib dran!";
      case MotivationLevel.low:
        return "Weiter!";
    }
  }
}