import '../domain/motivation_type.dart';
import '../domain/motivation_level.dart';

class MotivationMessageBuilder {
  static String build(MotivationType type, MotivationLevel level) {
    switch (type) {
      case MotivationType.pr:
        return _pr(level);
      case MotivationType.streak:
        return _streak(level);
      case MotivationType.milestone:
        return _milestone(level);
      case MotivationType.comeback:
        return _comeback(level);
      case MotivationType.neutral:
        return _neutral(level);
    }
  }

  static String _pr(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚨 Neues Level!";
      case MotivationLevel.high:
        return "💥 Kein Zufall!";
      case MotivationLevel.medium:
        return "Stark!";
      case MotivationLevel.low:
        return "Gut!";
    }
  }

  static String _streak(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🔥 Unaufhaltsam!";
      case MotivationLevel.high:
        return "⚡ Du bist im Flow!";
      case MotivationLevel.medium:
        return "Dranbleiben!";
      case MotivationLevel.low:
        return "Weiter so!";
    }
  }

  static String _milestone(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚀 Großes Level erreicht!";
      case MotivationLevel.high:
        return "Stark! Du ziehst durch!";
      case MotivationLevel.medium:
        return "Guter Fortschritt!";
      case MotivationLevel.low:
        return "Weiter!";
    }
  }

  static String _comeback(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
      case MotivationLevel.high:
        return "💥 Du bist zurück!";
      case MotivationLevel.medium:
        return "Zurück im Spiel!";
      case MotivationLevel.low:
        return "Weiter!";
    }
  }

  static String _neutral(MotivationLevel level) {
    return "Weiter!";
  }
}