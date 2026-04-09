class ProgressionInput {
  final double lastWeight;
  final int lastReps;
  final int targetReps;
  final List history;

  ProgressionInput({
    required this.lastWeight,
    required this.lastReps,
    required this.targetReps,
    required this.history,
  });
}