import '../domain/workout_session.dart';
import 'summary_view_data.dart';

class SummaryViewMapper {
  static SummaryViewData map(WorkoutSession session) {
    double volume = 0;
    int sets = 0;
    int reps = 0;

    for (final g in session.groups) {
      for (final e in g.exercises) {
        for (final s in e.sets) {
          volume += s.weight * s.reps;
          sets++;
          reps += s.reps;
        }
      }
    }

    return SummaryViewData(
      totalVolume: volume,
      totalSets: sets,
      totalReps: reps,
      exercises: session.groups
          .expand((g) => g.exercises)
          .length,
    );
  }
}