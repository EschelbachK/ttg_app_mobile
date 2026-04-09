import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/workout_training_plan.dart';

final planProvider = Provider<List<TrainingPlan>>((ref) {
  return [
    TrainingPlan(name: 'Full Body', exercises: [
      PlannedExercise(name: 'Squat', reps: 8, weight: 60),
      PlannedExercise(name: 'Bench Press', reps: 10, weight: 40),
    ]),
    TrainingPlan(name: 'Upper Body', exercises: [
      PlannedExercise(name: 'Pull-Up', reps: 8, weight: 0),
      PlannedExercise(name: 'Shoulder Press', reps: 10, weight: 30),
    ]),
  ];
});