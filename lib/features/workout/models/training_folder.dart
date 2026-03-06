import 'training_exercise.dart';

class TrainingFolder {
  final String id;
  final String name;
  final String planId;
  final List<TrainingExercise> exercises;

  TrainingFolder({
    required this.id,
    required this.name,
    required this.planId,
    required this.exercises,
  });

  factory TrainingFolder.fromJson(Map<String, dynamic> json) {
    return TrainingFolder(
      id: json['id'],
      name: json['name'],
      planId: json['planId'],
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => TrainingExercise.fromJson(e))
          .toList(),
    );
  }

  int get exerciseCount => exercises.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'planId': planId,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}