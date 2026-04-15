import '../../workout/domain/workout_history_entry.dart';

class AICoachEngine {
  final List<WorkoutHistoryEntry> history;

  AICoachEngine(this.history);

  // ─────────────────────────────
  // FATIGUE SCORE (0–100)
  // ─────────────────────────────
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

    final fatigue = ((avgVolume - last) / avgVolume) * 100;

    return fatigue.clamp(0, 100);
  }

  // ─────────────────────────────
  // OVERTRAINING DETECTION
  // ─────────────────────────────
  bool isOvertraining() {
    return fatigueScore() > 75;
  }

  // ─────────────────────────────
  // DELOAD RECOMMENDATION
  // ─────────────────────────────
  bool shouldDeload() {
    return fatigueScore() > 65;
  }

  // ─────────────────────────────
  // WEIGHT SUGGESTION
  // ─────────────────────────────
  double suggestWeight() {
    if (history.isEmpty) return 20;

    final last = history.last.weight;
    final fatigue = fatigueScore();

    if (fatigue > 70) {
      return last * 0.85; // deload
    } else if (fatigue < 30) {
      return last * 1.05; // progress
    }

    return last;
  }

  // ─────────────────────────────
  // PERFORMANCE TREND
  // ─────────────────────────────
  double performanceTrend() {
    if (history.length < 2) return 0;

    final last = history.last.weight * history.last.reps;
    final prev = history[history.length - 2].weight *
        history[history.length - 2].reps;

    return ((last - prev) / prev) * 100;
  }

  // ─────────────────────────────
  // COACH MESSAGE
  // ─────────────────────────────
  String coachMessage() {
    final f = fatigueScore();

    if (f > 80) return "⚠️ Overtraining detected — take a break";
    if (f > 65) return "🧠 High fatigue — consider deload";
    if (f < 30) return "🔥 You're fresh — push harder today";
    return "📈 Solid progression — keep going";
  }
}