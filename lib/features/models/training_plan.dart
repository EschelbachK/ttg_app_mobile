import 'training_folder.dart';

class TrainingPlan {
  final String id;
  final String name;
  final List<TrainingFolder> folders;

  TrainingPlan({
    required this.id,
    required this.name,
    required this.folders,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id'],
      name: json['name'],
      folders: (json['folders'] as List<dynamic>)
          .map((e) => TrainingFolder.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'folders': folders.map((e) => e.toJson()).toList(),
    };
  }
}