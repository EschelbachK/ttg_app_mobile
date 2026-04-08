import 'exercise_set.dart';

class Exercise {
  final String id;
  final String name;
  final List<ExerciseSet> sets;

  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
  });

  Exercise copyWith({
    String? id,
    String? name,
    List<ExerciseSet>? sets,
  }) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        sets: sets ?? this.sets,
      );

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final s = (json['sets'] as List?) ?? [];
    return Exercise(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      sets: s.map((e) => ExerciseSet.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sets': sets.map((e) => e.toJson()).toList(),
  };
}