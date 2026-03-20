import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';

class TrainingFolder {
  final String id;
  final String name;
  final String bodyRegion;
  final List<TrainingPlan> plans;

  TrainingFolder({
    required this.id,
    required this.name,
    required this.bodyRegion,
    required this.plans,
  });

  factory TrainingFolder.fromJson(Map<String, dynamic> json) {
    return TrainingFolder(
      id: json['id'],
      name: json['name'],
      bodyRegion: json['bodyRegion'] ?? '',
      plans: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyRegion': bodyRegion,
    };
  }

  TrainingFolder copyWith({
    String? id,
    String? name,
    String? bodyRegion,
    List<TrainingPlan>? plans,
  }) {
    return TrainingFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      plans: plans ?? this.plans,
    );
  }
}