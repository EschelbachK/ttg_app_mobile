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
}