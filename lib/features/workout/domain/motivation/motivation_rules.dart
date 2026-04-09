import '../domain/motivation_level.dart';

class MotivationRules {
  static MotivationLevel prLevel(int reps, double weight) {
    if (weight >= 5 || reps >= 5) return MotivationLevel.extreme;
    if (weight >= 2.5 || reps >= 3) return MotivationLevel.high;
    if (reps >= 2) return MotivationLevel.medium;
    return MotivationLevel.low;
  }

  static MotivationLevel streakLevel(int days) {
    if (days >= 30) return MotivationLevel.extreme;
    if (days >= 14) return MotivationLevel.high;
    if (days >= 7) return MotivationLevel.medium;
    return MotivationLevel.low;
  }

  static int priority(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return 4;
      case MotivationLevel.high:
        return 3;
      case MotivationLevel.medium:
        return 2;
      case MotivationLevel.low:
        return 1;
    }
  }
}