enum InsightType {
  progress,
  plateau,
  regression,
  consistency,
  pr,
}

class WorkoutInsight {
  final InsightType type;
  final String message;

  const WorkoutInsight({
    required this.type,
    required this.message,
  });
}