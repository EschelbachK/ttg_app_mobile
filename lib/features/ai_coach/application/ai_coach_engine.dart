import '../../history/application/history_service.dart';
import '../../workout/domain/workout_history_entry.dart';

class AICoachEngine {
  final HistoryService historyService;

  AICoachEngine(this.historyService);

  List<WorkoutHistoryEntry> get history => historyService.getAll();

  String _c(String text) => "😈: $text";

  double fatigueScore() {
    if (history.isEmpty) return 0;

    final last10 = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    final avgVolume = last10
        .map((e) => e.weight * e.reps)
        .reduce((a, b) => a + b) /
        last10.length;

    final last = history.last.weight * history.last.reps;

    if (avgVolume == 0) return 0;

    final fatigue = ((avgVolume - last) / avgVolume) * 100;
    return fatigue.clamp(0, 100);
  }

  bool isOvertraining() => fatigueScore() > 75;

  bool shouldDeload() => fatigueScore() > 65;

  double suggestWeight() {
    if (history.isEmpty) return 20;

    final last = history.last.weight;
    final fatigue = fatigueScore();

    if (fatigue > 70) return last * 0.85;
    if (fatigue < 30) return last * 1.05;

    return last;
  }

  double performanceTrend() {
    if (history.length < 2) return 0;

    final last = history.last.weight * history.last.reps;
    final prev =
        history[history.length - 2].weight *
            history[history.length - 2].reps;

    if (prev == 0) return 0;

    return ((last - prev) / prev) * 100;
  }

  String coachMessage() {
    final fatigue = fatigueScore();
    final trend = performanceTrend();

    if (fatigue > 80) {
      return _c("Zu viel Druck. Dein Körper braucht Pause!");
    }

    if (fatigue > 65) {
      return _c("Hohe Belastung. Reduziere Gewicht oder Volumen!");
    }

    if (trend > 5) {
      return _c("Du wirst stärker. Genau so!");
    }

    if (trend < -5) {
      return _c("Leistung fällt. Fokus auf Technik und Erholung!");
    }

    if (fatigue < 30) {
      return _c("Da geht mehr. Erhöhe das Gewicht!");
    }

    return _c("Stabil. Bleib dran!");
  }
}