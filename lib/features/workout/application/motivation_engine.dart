import '../domain/workout_session.dart';
import '../domain/motivation_badge.dart';
import '../domain/streak_tracker.dart';

class MotivationEngine {
  final StreakTracker streak = StreakTracker();
  final List<MotivationBadge> badges = [];

  void updateStreak(WorkoutSession session) {
    streak.update(session.startedAt);
  }

  List<String> checkPRs(String exerciseId, List<ExerciseSession> exercises) {
    final List<String> newPRs = [];
    final exercise = exercises.firstWhere((e) => e.id == exerciseId);
    if (exercise.sets.isEmpty) return newPRs;
    final lastSet = exercise.sets.last;
    final maxWeight = exercise.sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
    if (lastSet.weight == maxWeight) {
      badges.add(MotivationBadge(name: 'PR', description: 'New personal record in ${exercise.name}'));
      newPRs.add(exercise.name);
    }
    return newPRs;
  }
}