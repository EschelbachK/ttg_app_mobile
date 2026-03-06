class ExerciseCatalog {

  final String id;
  final String name;
  final String bodyRegion;
  final String equipment;

  ExerciseCatalog({
    required this.id,
    required this.name,
    required this.bodyRegion,
    required this.equipment,
  });

  factory ExerciseCatalog.fromJson(Map<String, dynamic> json) {
    return ExerciseCatalog(
      id: json['id'],
      name: json['name'],
      bodyRegion: json['bodyRegion'],
      equipment: json['equipment'],
    );
  }
}