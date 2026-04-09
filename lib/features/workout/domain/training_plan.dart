class TrainingPlan {
  final List<PlannedExercise> exercises;

  TrainingPlan({required this.exercises});
}

class PlannedExercise {
  final String name;
  final int reps;
  final double weight;

  PlannedExercise({
    required this.name,
    required this.reps,
    required this.weight,
  });
}