class TrainingExercise {
  final String id;
  final String name;

  TrainingExercise({
    required this.id,
    required this.name,
  });

  factory TrainingExercise.fromJson(Map<String, dynamic> json) {
    return TrainingExercise(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}