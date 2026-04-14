import 'package:fl_chart/fl_chart.dart';
import '../../domain/workout_history_entry.dart';

class ProgressChartData {
  final List<FlSpot> weight;
  final List<FlSpot> reps;
  final List<FlSpot> volume;

  ProgressChartData({
    required this.weight,
    required this.reps,
    required this.volume,
  });

  static ProgressChartData build(List<WorkoutHistoryEntry> history) {
    final weight = <FlSpot>[];
    final reps = <FlSpot>[];
    final volume = <FlSpot>[];

    for (var i = 0; i < history.length; i++) {
      final h = history[i];
      final x = i.toDouble();

      weight.add(FlSpot(x, h.weight));
      reps.add(FlSpot(x, h.reps.toDouble()));
      volume.add(FlSpot(x, h.weight * h.reps));
    }

    return ProgressChartData(
      weight: weight,
      reps: reps,
      volume: volume,
    );
  }
}