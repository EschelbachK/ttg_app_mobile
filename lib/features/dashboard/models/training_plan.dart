import 'exercise.dart';

class TrainingPlan {

  final String id;
  final String name;
  final List<Exercise> exercises;

  /// 🔥 NEU: Herkunft speichern
  final String? originFolderName;

  TrainingPlan({
    required this.id,
    required this.name,
    this.exercises = const [],
    this.originFolderName, // 🔥 NEU
  });

  TrainingPlan copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
    String? originFolderName, // 🔥 NEU
  }) {
    return TrainingPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      originFolderName: originFolderName ?? this.originFolderName, // 🔥 NEU
    );
  }
}