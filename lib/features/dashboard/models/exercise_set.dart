class ExerciseSet {
  final double weight;
  final int reps;

  ExerciseSet({
    required this.weight,
    required this.reps,
  });

  ExerciseSet copyWith({
    double? weight,
    int? reps,
  }) {
    return ExerciseSet(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
    );
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      reps: (json['reps'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
    };
  }
}