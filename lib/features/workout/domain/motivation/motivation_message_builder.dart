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
        return "🚨 Neues Level erreicht! Das ist echtes Wachstum!";
      case MotivationLevel.high:
        return "💥 Stark! Du wirst sichtbar besser!";
      case MotivationLevel.medium:
        return "Gute Steigerung! Genau so weiter!";
      case MotivationLevel.low:
        return "Solider Fortschritt! Dranbleiben!";
    }
  }

  static String _streak(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🔥 Absolute Konstanz! Genau das bringt dich voran!";
      case MotivationLevel.high:
        return "⚡ Du bist im Rhythmus! Halte ihn!";
      case MotivationLevel.medium:
        return "Gute Serie! Bleib konsequent!";
      case MotivationLevel.low:
        return "Dranbleiben! Konstanz gewinnt!";
    }
  }

  static String _milestone(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
        return "🚀 Großer Meilenstein! Das zahlt sich aus!";
      case MotivationLevel.high:
        return "Stark! Nächstes Level erreicht!";
      case MotivationLevel.medium:
        return "Guter Fortschritt! Weiter aufbauen!";
      case MotivationLevel.low:
        return "Weiter! Schritt für Schritt!";
    }
  }

  static String _comeback(MotivationLevel level) {
    switch (level) {
      case MotivationLevel.extreme:
      case MotivationLevel.high:
        return "💥 Starker Wiedereinstieg! Jetzt dranbleiben!";
      case MotivationLevel.medium:
        return "Zurück im Flow! Weiter geht’s!";
      case MotivationLevel.low:
        return "Wieder gestartet! Bleib dran!";
    }
  }

  static String _neutral() {
    return "Weiter! Fokus halten!";
  }
}