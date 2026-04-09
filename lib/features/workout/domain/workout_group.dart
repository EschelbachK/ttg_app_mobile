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
}