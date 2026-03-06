import 'set_entry.dart';

class TrainingExerciseDetails {
  final String id;
  final String name;
  final String folderId;
  final List<SetEntry> sets;

  TrainingExerciseDetails({
    required this.id,
    required this.name,
    required this.folderId,
    required this.sets,
  });

  factory TrainingExerciseDetails.fromJson(Map<String, dynamic> json) {
    return TrainingExerciseDetails(
      id: json['id'],
      name: json['name'],
      folderId: json['folderId'],
      sets: (json['sets'] as List<dynamic>)
          .map((e) => SetEntry.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'folderId': folderId,
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}