import 'exercise.dart';

class TrainingPlan {

  final String id;
  final String name;
  final List<Exercise> exercises;

  TrainingPlan({
    required this.id,
    required this.name,
    this.exercises = const [],
  });

  TrainingPlan copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
  }) {
    return TrainingPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }
}