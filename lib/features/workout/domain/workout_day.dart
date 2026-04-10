import 'workout_group.dart';

class WorkoutDay {
  final String name;
  final List<WorkoutGroup> groups;

  const WorkoutDay({
    required this.name,
    required this.groups,
  });
}