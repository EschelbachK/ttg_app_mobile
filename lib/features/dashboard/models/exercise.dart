import 'exercise_set.dart';

class Exercise {
  final String name;
  final List<ExerciseSet> sets;

  const Exercise({
    required this.name,
    required this.sets,
  });

  Exercise copyWith({
    String? name,
    List<ExerciseSet>? sets,
  }) =>
      Exercise(
        name: name ?? this.name,
        sets: sets ?? this.sets,
      );

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final s = (json['sets'] as List?) ?? [];
    return Exercise(
      name: (json['name'] ?? json['title'] ?? '').toString(),
      sets: s.map((e) => ExerciseSet.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'sets': sets.map((e) => e.toJson()).toList(),
  };
}