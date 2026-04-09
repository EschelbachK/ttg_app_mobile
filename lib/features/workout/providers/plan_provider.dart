import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';

final planProvider = Provider<List<TrainingPlan>>((ref) {
  return [
    TrainingPlan(
      id: '1',
      name: 'Full Body',
      exercises: [
        Exercise(name: 'Squat', reps: 8, weight: 60),
        Exercise(name: 'Bench Press', reps: 10, weight: 40),
      ],
    ),
    TrainingPlan(
      id: '2',
      name: 'Upper Body',
      exercises: [
        Exercise(name: 'Pull-Up', reps: 8, weight: 0),
        Exercise(name: 'Shoulder Press', reps: 10, weight: 30),
      ],
    ),
  ];
});