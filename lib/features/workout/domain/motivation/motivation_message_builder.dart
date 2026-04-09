import 'motivation_type.dart';
import 'motivation_level.dart';

class MotivationMessageBuilder {
  static String build(MotivationType type, MotivationLevel level) {
    switch (type) {
      case MotivationType.pr:
        return _progress(level);
      case MotivationType.streak:
        return _streak(level);
      case MotivationType.milestone:
        return _milestone(level);
      case MotivationType.comeback:
        return _comeback(level);
      case MotivationType.neutral:
        return _neutral();
    }
  }

  static String _progress(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚨 Neues Level erreicht!";
      case MotivationLevel.high:
        return "💥 Kein Zufall! Du wirst stärker!";
      case MotivationLevel.medium:
        return "Stark! Das ist Fortschritt!";
      case MotivationLevel.low:
        return "Gut! Weiter so!";
    }
  }

  static String _streak(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🔥 Unaufhaltsam! Du ziehst durch!";
      case MotivationLevel.high:
        return "⚡ Du bist im Flow! Bleib dran!";
      case MotivationLevel.medium:
        return "Dranbleiben! Du bist auf dem richtigen Weg!";
      case MotivationLevel.low:
        return "Weiter so!";
    }
  }

  static String _milestone(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚀 Riesiger Fortschritt! Das ist ein Meilenstein!";
      case MotivationLevel.high:
        return "Stark! Du erreichst neue Levels!";
      case MotivationLevel.medium:
        return "Guter Fortschritt! Bleib dran!";
      case MotivationLevel.low:
        return "Weiter!";
    }
  }

  static String _comeback(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
      case MotivationLevel.high:
        return "💥 Du bist zurück! Genau jetzt zählt’s!";
      case MotivationLevel.medium:
        return "Zurück im Spiel! Weiter geht’s!";
      case MotivationLevel.low:
        return "Weiter!";
    }
  }

  static String _neutral() {
    return "Weiter!";
  }
}