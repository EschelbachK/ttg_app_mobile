class ExerciseCatalogItem {

  final String id;
  final String name;
  final String imageUrl;

  ExerciseCatalogItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ExerciseCatalogItem.fromJson(Map<String, dynamic> json) {
    return ExerciseCatalogItem(
      id: json["id"],
      name: json["name"],
      imageUrl: json["imageUrl"] ?? "",
    );
  }
}