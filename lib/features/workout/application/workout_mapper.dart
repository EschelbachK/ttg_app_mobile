import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_folder.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise.dart';
import 'package:ttg_app_mobile/features/workout/domain/workout_session.dart';
import 'package:ttg_app_mobile/features/workout/domain/set_log.dart';
import 'package:ttg_app_mobile/features/workout/domain/next_session_suggestion.dart';

import '../../dashboard/models/exercise_set.dart';

class WorkoutMapper {
  static List<ExerciseSession> fromPlan({
    required TrainingPlan plan,
    required List<TrainingFolder> folders,
  }) {
    final exercises = <ExerciseSession>[];

    final planFolders = folders
        .where((f) => f.trainingPlanId == plan.id)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (planFolders.isNotEmpty) {
      var order = 0;

      for (final folder in planFolders) {
        for (final e in folder.exercises) {
          exercises.add(
            ExerciseSession(
              id: '${DateTime.now().toIso8601String()}$order',
              name: e.name,
              order: order++,
              sets: [
                SetLog(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  weight: e.sets.isNotEmpty ? e.sets.first.weight : 0,
                  reps: e.sets.isNotEmpty ? e.sets.first.reps : 0,
                ),
              ],
            ),
          );
        }
      }

      return exercises;
    }

    return plan.exercises.asMap().entries.map((e) {
      final p = e.value;

      return ExerciseSession(
        id: '${DateTime.now().toIso8601String()}${e.key}',
        name: p.name,
        order: e.key,
        sets: [
          SetLog(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            weight: p.sets.isNotEmpty ? p.sets.first.weight : 0,
            reps: p.sets.isNotEmpty ? p.sets.first.reps : 0,
          ),
        ],
      );
    }).toList();
  }

  static TrainingPlan fromSuggestions(
      List<NextSessionSuggestion> suggestions,
      ) {
    return TrainingPlan(
      id: DateTime.now().toIso8601String(),
      name: 'Next Session',
      exercises: suggestions.map((s) {
        return Exercise(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: s.exerciseName,
          bodyRegion: "GANZKOERPER", // oder smarter mapping später
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
  }}