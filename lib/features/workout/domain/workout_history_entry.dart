class WorkoutHistoryEntry {
  final String id;
  final String exerciseName;
  final double weight;
  final int reps;
  final DateTime date;
  final String sessionId;

  const WorkoutHistoryEntry({
    required this.id,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.date,
    required this.sessionId,
  });
}