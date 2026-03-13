class ExerciseCatalogItem {

  final String id;
  final String name;
  final String imageUrl;

  // NEUE FELDER
  final String bodyRegion;
  final String equipment;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final String exerciseType;
  final String difficulty;
  final String animationUrl;

  ExerciseCatalogItem({
    required this.id,
    required this.name,
    required this.imageUrl,

    // NEU
    required this.bodyRegion,
    required this.equipment,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.exerciseType,
    required this.difficulty,
    required this.animationUrl,
  });

  factory ExerciseCatalogItem.fromJson(Map<String, dynamic> json) {
    return ExerciseCatalogItem(
      id: json["id"],
      name: json["name"],
      imageUrl: json["imageUrl"] ?? "",

      // NEU
      bodyRegion: json["bodyRegion"] ?? "",
      equipment: json["equipment"] ?? "",
      primaryMuscle: json["primaryMuscle"] ?? "",
      secondaryMuscles:
      List<String>.from(json["secondaryMuscles"] ?? []),
      exerciseType: json["exerciseType"] ?? "",
      difficulty: json["difficulty"] ?? "",
      animationUrl: json["animationUrl"] ?? "",
    );
  }
}