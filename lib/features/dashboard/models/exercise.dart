import 'exercise_set.dart';

class Exercise {
  final String id;
  final String name;
  final String bodyRegion;
  final List<ExerciseSet> sets;

  const Exercise({
    required this.id,
    required this.name,
    required this.bodyRegion,
    required this.sets,
  });

  Exercise copyWith({String? id, String? name, String? bodyRegion, List<ExerciseSet>? sets}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        bodyRegion: bodyRegion ?? this.bodyRegion,
        sets: sets ?? this.sets,
      );

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final s = (json['sets'] as List?) ?? [];
    return Exercise(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      bodyRegion: (json['bodyRegion'] ?? '').toString(),
      sets: s.map((e) => ExerciseSet.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'bodyRegion': bodyRegion, 'sets': sets.map((e) => e.toJson()).toList()};
}