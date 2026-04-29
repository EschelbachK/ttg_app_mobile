import 'exercise.dart';

class TrainingPlan {
  final String id;
  final String name;
  final int order;
  final List<Exercise> exercises;
  final List<dynamic> folders;
  final String? originFolderName;
  final bool isArchived;

  const TrainingPlan({
    required this.id,
    required this.name,
    this.order = 0,
    required this.exercises,
    this.originFolderName,
    this.folders = const [],
    this.isArchived = false,
  });

  TrainingPlan copyWith({
    String? id,
    String? name,
    int? order,
    List<Exercise>? exercises,
    String? originFolderName,
    List<dynamic>? folders,
    bool? isArchived,
  }) =>
      TrainingPlan(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        exercises: exercises ?? this.exercises,
        originFolderName: originFolderName ?? this.originFolderName,
        folders: folders ?? this.folders,
        isArchived: isArchived ?? this.isArchived,
      );

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    final ex = (json['exercises'] as List?) ?? [];
    return TrainingPlan(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['title'] ?? json['name'] ?? '').toString(),
      order: json['order'] is int ? json['order'] as int : int.tryParse('${json['order']}') ?? 0,
      exercises: ex.map((e) => Exercise.fromJson(e)).toList(),
      originFolderName: json['originFolderName']?.toString(),
      folders: (json['folders'] as List?) ?? [],
      isArchived: json['isArchived'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': name,
    'order': order,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'originFolderName': originFolderName,
    'folders': folders,
    'isArchived': isArchived,
  };
}