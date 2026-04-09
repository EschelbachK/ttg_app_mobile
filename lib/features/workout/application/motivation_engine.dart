import '../domain/workout_session.dart';
import '../domain/motivation_badge.dart';
import '../domain/streak_tracker.dart';

class MotivationEngine {
  final StreakTracker streak = StreakTracker();
  final List<MotivationBadge> badges = [];

  void updateStreak(WorkoutSession session) {
    streak.update(session.startedAt);
  }

  void checkPRs(String exerciseId, List<ExerciseSession> exercises) {
    final exercise = exercises.firstWhere((e) => e.id == exerciseId);
    if (exercise.sets.isEmpty) return;
    final lastSet = exercise.sets.last;
    final isPR = lastSet.weight == (exercise.sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b));
    if (isPR) badges.add(MotivationBadge(name: 'PR', description: 'New personal record in ${exercise.name}'));
  }
}