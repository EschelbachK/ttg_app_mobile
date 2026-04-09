import 'set_log.dart';

class WorkoutSession {
  final String id;
  final DateTime startedAt;
  final List<ExerciseSession> exercises;

  WorkoutSession({
    required this.id,
    required this.startedAt,
    required this.exercises,
  });

  WorkoutSession copyWith({
    List<ExerciseSession>? exercises,
  }) {
    return WorkoutSession(
      id: id,
      startedAt: startedAt,
      exercises: exercises ?? this.exercises,
    );
  }
}

class ExerciseSession {
  final String id;
  final String name;
  final int order;
  final List<SetLog> sets;

  ExerciseSession({
    required this.id,
    required this.name,
    required this.order,
    required this.sets,
  });

  ExerciseSession copyWith({
    List<SetLog>? sets,
  }) {
    return ExerciseSession(
      id: id,
      name: name,
      order: order,
      sets: sets ?? this.sets,
    );
  }
}