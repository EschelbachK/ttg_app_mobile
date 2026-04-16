import '../../features/workout/domain/workout_session.dart';
import '../../features/workout/domain/set_log.dart';
import 'app_event.dart';

class WorkoutFinishedEvent extends AppEvent {
  final WorkoutSession session;

  WorkoutFinishedEvent(this.session);
}

class SetCompletedEvent extends AppEvent {
  final String exerciseId;
  final SetLog set;

  SetCompletedEvent({
    required this.exerciseId,
    required this.set,
  });
}

class PRDetectedEvent extends AppEvent {
  final String exerciseName;
  final double weight;
  final int reps;

  PRDetectedEvent({
    required this.exerciseName,
    required this.weight,
    required this.reps,
  });
}

class LevelUpEvent extends AppEvent {
  final int newLevel;

  LevelUpEvent(this.newLevel);
}

class StreakUpdatedEvent extends AppEvent {
  final int streakDays;

  StreakUpdatedEvent(this.streakDays);
}