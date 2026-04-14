import '../../domain/workout_session.dart';
import '../../domain/workout_group.dart';
import '../../domain/workout_session.dart';
import '../../domain/set_log.dart';

class WorkoutSessionFactory {
  static WorkoutSession createFallback() {
    return WorkoutSession(
      id: DateTime.now().toIso8601String(),
      startedAt: DateTime.now(),
      groups: [
        WorkoutGroup(
          name: 'Default',
          order: 0,
          exercises: [
            ExerciseSession(
              id: DateTime.now().toIso8601String(),
              name: 'Exercise',
              order: 0,
              sets: [
                SetLog(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  weight: 0,
                  reps: 0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}