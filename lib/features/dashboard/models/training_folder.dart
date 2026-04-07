import 'exercise.dart';

class TrainingFolder {
  final String id;
  final String name;
  final String trainingPlanId;
  final String trainingPlanName;
  final String bodyRegion;
  final List<dynamic> plans;
  final List<Exercise> exercises;
  final bool archived;
  final int order; // <- neu hinzugefügt

  TrainingFolder({
    required this.id,
    required this.name,
    required this.trainingPlanId,
    required this.trainingPlanName,
    required this.bodyRegion,
    required this.plans,
    required this.exercises,
    this.archived = false,
    this.order = 0, // <- Standardwert
  });

  factory TrainingFolder.fromJson(Map<String, dynamic> json) {
    final exercisesJson = (json['exercises'] as List?) ?? [];
    final planId = (json['trainingPlanId'] ?? json['planId'] ?? '').toString();

    return TrainingFolder(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      trainingPlanId: planId,
      trainingPlanName: (json['trainingPlanName'] ?? json['planName'] ?? '').toString(),
      bodyRegion: (json['bodyRegion'] ?? '').toString(),
      plans: [],
      exercises: exercisesJson.map((e) => Exercise.fromJson(e)).toList(),
      archived: json['archived'] ?? false,
      order: (json['order'] ?? 0) as int, // <- order aus JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trainingPlanId': trainingPlanId,
      'trainingPlanName': trainingPlanName,
      'bodyRegion': bodyRegion,
      'plans': plans,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'archived': archived,
      'order': order, // <- order mitgeben
    };
  }

  TrainingFolder copyWith({
    String? id,
    String? name,
    String? trainingPlanId,
    String? trainingPlanName,
    String? bodyRegion,
    List<dynamic>? plans,
    List<Exercise>? exercises,
    bool? archived,
    int? order, // <- copyWith unterstützt order
  }) {
    return TrainingFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      trainingPlanId: trainingPlanId ?? this.trainingPlanId,
      trainingPlanName: trainingPlanName ?? this.trainingPlanName,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      plans: plans ?? this.plans,
      exercises: exercises ?? this.exercises,
      archived: archived ?? this.archived,
      order: order ?? this.order,
    );
  }
}