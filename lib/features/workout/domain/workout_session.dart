import 'set_log.dart';
import 'workout_group.dart';

class WorkoutSession {
  final String id;
  final String? planId;
  final DateTime startedAt;
  final List<WorkoutGroup> groups;

  const WorkoutSession({
    required this.id,
    this.planId,
    required this.startedAt,
    required this.groups,
  });

  WorkoutSession copyWith({
    String? planId,
    List<WorkoutGroup>? groups,
  }) =>
      WorkoutSession(
        id: id,
        planId: planId ?? this.planId,
        startedAt: startedAt,
        groups: groups ?? this.groups,
      );
}

class ExerciseSession {
  final String id;
  final String name;
  final int order;
  final List<SetLog> sets;

  const ExerciseSession({
    required this.id,
    required this.name,
    required this.order,
    required this.sets,
  });

  ExerciseSession copyWith({
    List<SetLog>? sets,
  }) =>
      ExerciseSession(
        id: id,
        name: name,
        order: order,
        sets: sets ?? this.sets,
      );
}