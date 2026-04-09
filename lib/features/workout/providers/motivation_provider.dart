import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/motivation_engine.dart';
import '../domain/workout_session.dart';

final motivationProvider = ChangeNotifierProvider<MotivationNotifier>((ref) => MotivationNotifier());

class MotivationNotifier extends ChangeNotifier {
  final MotivationEngine engine = MotivationEngine();

  void updateStreakFromSession(WorkoutSession session) {
    engine.updateStreak(session);
    notifyListeners();
  }

  void checkPRs(String exerciseId, List<ExerciseSession> exercises) {
    engine.checkPRs(exerciseId, exercises);
    notifyListeners();
  }
}