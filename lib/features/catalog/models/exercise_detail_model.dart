class ExerciseMedia {
  final String image;
  final String thumbnail;
  final String animation;

  const ExerciseMedia({
    required this.image,
    required this.thumbnail,
    required this.animation,
  });

  factory ExerciseMedia.fromJson(Map<String, dynamic> json) => ExerciseMedia(
    image: json['image'] ?? '',
    thumbnail: json['thumbnail'] ?? '',
    animation: json['animation'] ?? '',
  );
}

class ExerciseDetailModel {
  final String id;
  final String name;
  final String bodyRegion;
  final String equipment;
  final String difficulty;
  final ExerciseMedia media;
  final List<String> instructions;
  final List<String> tips;
  final List<String> commonMistakes;

  const ExerciseDetailModel({
    required this.id,
    required this.name,
    required this.bodyRegion,
    required this.equipment,
    required this.difficulty,
    required this.media,
    required this.instructions,
    required this.tips,
    required this.commonMistakes,
  });

  factory ExerciseDetailModel.fromJson(Map<String, dynamic> json) => ExerciseDetailModel(
    id: json['id'] as String,
    name: json['name'] as String,
    bodyRegion: json['bodyRegion'] as String,
    equipment: json['equipment'] as String,
    difficulty: json['difficulty'] as String,
    media: ExerciseMedia.fromJson(json['media'] as Map<String, dynamic>),
    instructions: (json['instructions'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [],
    tips: (json['tips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    commonMistakes: (json['commonMistakes'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [],
  );
}