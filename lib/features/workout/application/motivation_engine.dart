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
    final results = <MotivationResult>[];

    final reps = event.repsDiff ?? 0;
    final weight = event.weightDiff ?? 0;

    if (reps > 0 || weight > 0) {
      final level = MotivationRules.prLevel(reps, weight);
      results.add(MotivationResult(
        type: MotivationType.pr,
        level: level,
        message: MotivationMessageBuilder.build(MotivationType.pr, level),
      ));
    }

    if (event.streakDays > 0) {
      final level = MotivationRules.streakLevel(event.streakDays);
      results.add(MotivationResult(
        type: MotivationType.streak,
        level: level,
        message: MotivationMessageBuilder.build(MotivationType.streak, level),
      ));
    }

    if (event.isComeback) {
      results.add(MotivationResult(
        type: MotivationType.comeback,
        level: MotivationLevel.high,
        message: MotivationMessageBuilder.build(
          MotivationType.comeback,
          MotivationLevel.high,
        ),
      ));
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
}