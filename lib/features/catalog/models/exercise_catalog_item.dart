class ExerciseCatalogItem {
  final String id;
  final String name;
  final String imageUrl;
  final String bodyRegion;
  final String equipment;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final String exerciseType;
  final String difficulty;
  final String animationUrl;
  final List<String> tags;

  const ExerciseCatalogItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bodyRegion,
    required this.equipment,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.exerciseType,
    required this.difficulty,
    required this.animationUrl,
    this.tags = const [],
  });

  factory ExerciseCatalogItem.fromJson(Map<String, dynamic> json) {
    return ExerciseCatalogItem(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      bodyRegion: json["bodyRegion"] ?? "",
      equipment: json["equipment"] ?? "",
      primaryMuscle: json["primaryMuscle"] ?? "",
      secondaryMuscles: json["secondaryMuscles"] is List
          ? List<String>.from(json["secondaryMuscles"])
          : [],
      exerciseType: json["exerciseType"] ?? "",
      difficulty: json["difficulty"] ?? "",
      animationUrl: json["animationUrl"] ?? "",
      tags: json["tags"] is List ? List<String>.from(json["tags"]) : [],
    );
  }
}