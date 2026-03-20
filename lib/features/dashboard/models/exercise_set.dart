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
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
    };
  }
}