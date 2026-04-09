class SetLog {
  final String id;
  final double weight;
  final int reps;
  final bool completed;

  SetLog({
    required this.id,
    required this.weight,
    required this.reps,
    this.completed = false,
  });

  SetLog copyWith({
    double? weight,
    int? reps,
    bool? completed,
  }) {
    return SetLog(
      id: id,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
    );
  }
}