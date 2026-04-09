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

  MotivationEvent copyWith({
    int? repsDiff,
    double? weightDiff,
    int? streakDays,
    bool? isComeback,
    int? totalWorkouts,
  }) {
    return MotivationEvent(
      repsDiff: repsDiff ?? this.repsDiff,
      weightDiff: weightDiff ?? this.weightDiff,
      streakDays: streakDays ?? this.streakDays,
      isComeback: isComeback ?? this.isComeback,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
    );
  }
}