import 'exercise_set.dart';

class TrainingExercise {
  final String id;
  final String name;
  final String bodyRegion;
  final List<ExerciseSet> sets;
  final String equipment;
  final String difficulty;
  final String imageUrl;
  final String primaryMuscle;

  TrainingExercise({
    required this.id,
    required this.name,
    required this.bodyRegion,
    required this.sets,
    this.equipment = '',
    this.difficulty = '',
    this.imageUrl = '',
    this.primaryMuscle = '',
  });

  TrainingExercise copyWith({
    String? id,
    String? name,
    String? bodyRegion,
    List<ExerciseSet>? sets,
    String? equipment,
    String? difficulty,
    String? imageUrl,
    String? primaryMuscle,
  }) {
    return TrainingExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      sets: sets ?? this.sets,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
    );
  }

  factory TrainingExercise.fromJson(Map<String, dynamic> json) {
    final setList = List<Map<String, dynamic>>.from(json['sets'] ?? []);
    return TrainingExercise(
      id: json['id'],
      name: json['name'],
      bodyRegion: json['bodyRegion'] ?? '',
      sets: setList.map((e) => ExerciseSet.fromJson(e)).toList(),
      equipment: json['equipment'] ?? '',
      difficulty: json['difficulty'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      primaryMuscle: json['primaryMuscle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bodyRegion': bodyRegion,
    'sets': sets.map((e) => e.toJson()).toList(),
    'equipment': equipment,
    'difficulty': difficulty,
    'imageUrl': imageUrl,
    'primaryMuscle': primaryMuscle,
  };
}