class ExerciseSet {
  final double weight;
  final int reps;

  const ExerciseSet({required this.weight, required this.reps});

  ExerciseSet copyWith({double? weight, int? reps}) => ExerciseSet(
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
  );

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
    weight: (json['weight'] as num?)?.toDouble() ?? 0,
    reps: (json['repetitions'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {'weight': weight, 'repetitions': reps};
}