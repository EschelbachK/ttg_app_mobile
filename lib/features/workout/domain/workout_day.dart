import 'package:ttg_app_mobile/features/workout/domain/workout_group.dart';

class WorkoutDay {
  final String name;
  final List<WorkoutGroup> groups;

  WorkoutDay({
    required this.name,
    required this.groups,
  });
}