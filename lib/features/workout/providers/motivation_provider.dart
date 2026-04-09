import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/motivation_engine.dart';
import '../domain/workout_session.dart';
import '../domain/workout_training_plan.dart';

final motivationProvider =
ChangeNotifierProvider<MotivationNotifier>((ref) => MotivationNotifier());

class MotivationNotifier extends ChangeNotifier {
  final MotivationEngine engine = MotivationEngine();

  void Function(int)? onStreak;
  void Function(List<String>)? onPR;

  void updateStreakFromSession(WorkoutSession session) {
    final oldStreak = engine.streak.streakCount;
    engine.updateStreak(session);
    if (engine.streak.streakCount > oldStreak) {
      onStreak?.call(engine.streak.streakCount);
    }
    notifyListeners();
  }

  void checkPRs(String exerciseId, List<ExerciseSession> exercises) {
    final List<String> newPRs = engine.checkPRs(exerciseId, exercises);
    if (newPRs.isNotEmpty) {
      onPR?.call(newPRs);
    }
    notifyListeners();
  }
}