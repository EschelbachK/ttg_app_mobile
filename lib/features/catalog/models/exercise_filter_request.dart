class ExerciseFilterRequest {
  final String? bodyRegion;
  final String? muscle;
  final String? equipment;
  final String? difficulty;
  final String? tag;
  final String? movementPattern;
  final int? page;
  final int? size;

  ExerciseFilterRequest({
    this.bodyRegion,
    this.muscle,
    this.equipment,
    this.difficulty,
    this.tag,
    this.movementPattern,
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bodyRegion != null) map['bodyRegion'] = bodyRegion;
    if (muscle != null) map['muscle'] = muscle;
    if (equipment != null) map['equipment'] = equipment;
    if (difficulty != null) map['difficulty'] = difficulty;
    if (tag != null) map['tag'] = tag;
    if (movementPattern != null) map['movementPattern'] = movementPattern;
    if (page != null) map['page'] = page;
    if (size != null) map['size'] = size;
    return map;
  }

  ExerciseFilterRequest copyWith({
    String? bodyRegion,
    String? muscle,
    String? equipment,
    String? difficulty,
    String? tag,
    String? movementPattern,
    int? page,
    int? size,
  }) {
    return ExerciseFilterRequest(
      bodyRegion: bodyRegion ?? this.bodyRegion,
      muscle: muscle ?? this.muscle,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      tag: tag ?? this.tag,
      movementPattern: movementPattern ?? this.movementPattern,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}