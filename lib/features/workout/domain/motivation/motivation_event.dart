class MotivationEvent {
  final int? repsDiff;
  final double? weightDiff;
  final int streakDays;
  final bool isComeback;
  final int totalWorkouts;

  const MotivationEvent({
    this.repsDiff,
    this.weightDiff,
    required this.streakDays,
    required this.isComeback,
    required this.totalWorkouts,
  });
}