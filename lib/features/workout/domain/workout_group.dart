import '../../dashboard/models/exercise.dart';

class WorkoutGroup {
  final String name;
  final List<Exercise> exercises;

  WorkoutGroup({
    required this.name,
    required this.exercises,
  });
}