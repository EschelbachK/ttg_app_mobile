class Exercise {

  final String id;
  final String category;
  final String name;

  final double weight;
  final int reps;
  final int sets;

  Exercise({
    required this.id,
    required this.category,
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
  });

  Exercise copyWith({
    String? id,
    String? category,
    String? name,
    double? weight,
    int? reps,
    int? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
    );
  }
}