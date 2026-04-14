import '../../domain/workout_session.dart';

class WorkoutSessionUpdater {
  static WorkoutSession updateSet({
    required WorkoutSession session,
    required String exerciseId,
    required String setId,
    double? weight,
    int? reps,
    bool? completed,
  }) {
    return session.copyWith(
      groups: session.groups.map((g) {
        return g.copyWith(
          exercises: g.exercises.map((e) {
            if (e.id != exerciseId) return e;

            return e.copyWith(
              sets: e.sets.map((x) {
                if (x.id != setId) return x;

                return x.copyWith(
                  weight: weight ?? x.weight,
                  reps: reps ?? x.reps,
                  completed: completed ?? x.completed,
                );
              }).toList(),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}