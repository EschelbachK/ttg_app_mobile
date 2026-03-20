import 'exercise.dart';

class TrainingPlan {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final String? originFolderName;

  TrainingPlan({
    required this.id,
    required this.name,
    required this.exercises,
    this.originFolderName,
  });

  TrainingPlan copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
    String? originFolderName,
  }) {
    return TrainingPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      originFolderName: originFolderName ?? this.originFolderName,
    );
  }

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id'],
      name: json['title'] ?? json['name'],
      exercises: (json['exercises'] as List?)
          ?.map((e) => Exercise.fromJson(e))
          .toList() ??
          [],
      originFolderName: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}