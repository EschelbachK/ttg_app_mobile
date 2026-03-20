import 'exercise_set.dart';

class Exercise {
  final String name;
  final List<ExerciseSet> sets;

  Exercise({
    required this.name,
    required this.sets,
  });

  Exercise copyWith({
    String? name,
    List<ExerciseSet>? sets,
  }) {
    return Exercise(
      name: name ?? this.name,
      sets: sets ?? this.sets,
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: (json['sets'] as List? ?? [])
          .map((e) => ExerciseSet.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}