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
  final int order;

  const TrainingFolder({
    required this.id,
    required this.name,
    required this.trainingPlanId,
    required this.trainingPlanName,
    required this.bodyRegion,
    required this.plans,
    required this.exercises,
    this.archived = false,
    this.order = 0,
  });

  TrainingFolder copyWith({
    String? id,
    String? name,
    String? trainingPlanId,
    String? trainingPlanName,
    String? bodyRegion,
    List<dynamic>? plans,
    List<Exercise>? exercises,
    bool? archived,
    int? order,
  }) =>
      TrainingFolder(
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

  factory TrainingFolder.fromJson(Map<String, dynamic> json) {
    final ex = (json['exercises'] as List?) ?? [];
    return TrainingFolder(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      trainingPlanId: (json['trainingPlanId'] ?? json['planId'] ?? '').toString(),
      trainingPlanName: (json['trainingPlanName'] ?? json['planName'] ?? '').toString(),
      bodyRegion: (json['bodyRegion'] ?? '').toString(),
      plans: [],
      exercises: ex.map((e) => Exercise.fromJson(e)).toList(),
      archived: json['archived'] ?? false,
      order: (json['order'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'trainingPlanId': trainingPlanId,
    'trainingPlanName': trainingPlanName,
    'bodyRegion': bodyRegion,
    'plans': plans,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'archived': archived,
    'order': order,
  };
}