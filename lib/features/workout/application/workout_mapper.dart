import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_folder.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise_set.dart';

import '../domain/workout_group.dart';
import '../domain/workout_session.dart';
import '../domain/set_log.dart';
import '../domain/next_session_suggestion.dart';

class WorkoutMapper {
  static List<WorkoutGroup> fromPlan({
    required TrainingPlan plan,
    required List<TrainingFolder> folders,
  }) {
    final now = DateTime.now();

    final planFolders = folders
        .where((f) => f.trainingPlanId == plan.id)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (planFolders.isNotEmpty) {
      var order = 0;

      return planFolders.map((folder) {
        return WorkoutGroup(
          name: folder.name,
          order: folder.order,
          exercises: folder.exercises.map((e) {
            return ExerciseSession(
              id: '${now.toIso8601String()}-$order',
              name: e.name,
              order: order++,
              sets: e.sets.map((s) {
                return SetLog(
                  id: '${now.millisecondsSinceEpoch}-${order}-${s.hashCode}',
                  weight: s.weight,
                  reps: s.reps,
                  completed: false,
                );
              }).toList(),
            );
          }).toList(),
        );
      }).toList();
    }

    return [
      WorkoutGroup(
        name: 'Default',
        order: 0,
        exercises: plan.exercises.asMap().entries.map((e) {
          final p = e.value;

          return ExerciseSession(
            id: '${now.toIso8601String()}-${e.key}',
            name: p.name,
            order: e.key,
            sets: p.sets.map((s) {
              return SetLog(
                id: '${now.millisecondsSinceEpoch}-${e.key}-${s.hashCode}',
                weight: s.weight,
                reps: s.reps,
                completed: false,
              );
            }).toList(),
          );
        }).toList(),
      ),
    ];
  }

  static TrainingPlan fromSuggestions(List<NextSessionSuggestion> suggestions) {
    final now = DateTime.now();

    return TrainingPlan(
      id: now.toIso8601String(),
      name: 'Next Session',
      exercises: suggestions.asMap().entries.map((e) {
        final s = e.value;

        return Exercise(
          id: '${now.millisecondsSinceEpoch}-${e.key}',
          name: s.exerciseName,
          bodyRegion: "GANZKOERPER",
          sets: [
            ExerciseSet(
              weight: s.weight,
              reps: s.reps,
            ),
          ],
        );
      }).toList(),
      folders: [],
    );
  }
}