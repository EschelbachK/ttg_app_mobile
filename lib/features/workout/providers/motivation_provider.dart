import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/motivation_engine.dart';
import '../application/motivation_state.dart';
import '../domain/motivation/motivation_event.dart';
import '../domain/motivation/motivation_level.dart';
import '../domain/workout_session.dart';

final motivationProvider =
ChangeNotifierProvider<MotivationNotifier>(
        (ref) => MotivationNotifier());

class MotivationNotifier extends ChangeNotifier {
  final MotivationEngine engine = MotivationEngine();

  MotivationState state = const MotivationState();

  Timer? _timer;

  void updateStreakFromSession(WorkoutSession session) {
    engine.updateStreak(session);
    notifyListeners();
  }

  void evaluate(MotivationEvent event) {
    final result = engine.evaluate(event);

    _timer?.cancel();

    _triggerHaptic(result.level);

    state = state.copyWith(
      last: result,
      visible: true,
      timestamp: DateTime.now(),
    );

    notifyListeners();

    _timer = Timer(const Duration(seconds: 4), () {
      state = state.copyWith(visible: false);
      notifyListeners();
    });
  }

  void _triggerHaptic(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.low:
        HapticFeedback.lightImpact();
        break;
      case MotivationLevel.medium:
        HapticFeedback.mediumImpact();
        break;
      case MotivationLevel.high:
      case MotivationLevel.extreme:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}