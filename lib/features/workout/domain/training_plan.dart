class TrainingPlan {
  final List<PlannedExercise> exercises;

  const TrainingPlan({required this.exercises});
}

class PlannedExercise {
  final String name;
  final int reps;
  final double weight;

  const PlannedExercise({
    required this.name,
    required this.reps,
    required this.weight,
  });
}