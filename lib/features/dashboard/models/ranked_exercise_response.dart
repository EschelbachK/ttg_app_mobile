import 'training_exercise.dart';

class RankedExerciseResponse {
  final TrainingExercise exercise;
  final int rank;

  RankedExerciseResponse({
    required this.exercise,
    required this.rank,
  });

  factory RankedExerciseResponse.fromJson(Map<String, dynamic> json) {
    return RankedExerciseResponse(
      exercise: TrainingExercise.fromJson(json['exercise']),
      rank: json['rank'],
    );
  }
}