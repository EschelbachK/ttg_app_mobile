import '../../history/application/history_service.dart';
import '../../workout/domain/workout_history_entry.dart';

class AICoachEngine {
  final HistoryService historyService;

  AICoachEngine(this.historyService);

  List<WorkoutHistoryEntry> get history =>
      historyService.getAll();

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

  bool isOvertraining() {
    return fatigueScore() > 75;
  }

  bool shouldDeload() {
    return fatigueScore() > 65;
  }

  double suggestWeight() {
    if (history.isEmpty) return 20;

    final last = history.last.weight;
    final fatigue = fatigueScore();

    if (fatigue > 70) {
      return last * 0.85;
    } else if (fatigue < 30) {
      return last * 1.05;
    }

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
    final f = fatigueScore();

    if (f > 80) return "⚠️ Overtraining detected — take a break";
    if (f > 65) return "🧠 High fatigue — consider deload";
    if (f < 30) return "🔥 You're fresh — push harder today";
    return "📈 Solid progression — keep going";
  }
}