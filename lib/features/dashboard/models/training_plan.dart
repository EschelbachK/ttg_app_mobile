import 'exercise.dart';

class TrainingPlan {
  final String id;
  final String name;

  /// Exercises auf Plan-Ebene (optional genutzt)
  final List<Exercise> exercises;

  /// 🔥 Vorbereitung für verschachtelte Struktur (Folders im Plan)
  final List<dynamic> folders;

  /// Optional: Herkunft (z.B. importiert aus Folder)
  final String? originFolderName;

  TrainingPlan({
    required this.id,
    required this.name,
    required this.exercises,
    this.originFolderName,
    this.folders = const [],
  });

  TrainingPlan copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
    String? originFolderName,
    List<dynamic>? folders,
  }) {
    return TrainingPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      originFolderName: originFolderName ?? this.originFolderName,
      folders: folders ?? this.folders,
    );
  }

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    final exercisesJson = (json['exercises'] as List?) ?? [];

    return TrainingPlan(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['title'] ?? json['name'] ?? '').toString(),

      exercises: exercisesJson
          .map((e) => Exercise.fromJson(e))
          .toList(),

      originFolderName: json['originFolderName']?.toString(),

      /// 🔥 wichtig: fallback auf leere Liste
      folders: (json['folders'] as List?) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'originFolderName': originFolderName,
      'folders': folders,
    };
  }
}