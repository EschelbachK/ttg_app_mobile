import 'workout_session.dart';

class WorkoutGroup {
  final String name;
  final int order;
  final List<ExerciseSession> exercises;

  const WorkoutGroup({
    required this.name,
    required this.order,
    required this.exercises,
  });

  WorkoutGroup copyWith({
    String? name,
    int? order,
    List<ExerciseSession>? exercises,
  }) {
    return WorkoutGroup(
      name: name ?? this.name,
      order: order ?? this.order,
      exercises: exercises ?? this.exercises,
    );
  }
}