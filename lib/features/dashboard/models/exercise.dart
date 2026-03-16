import 'exercise_set.dart';

class Exercise {

  final String id;
  final String category;
  final String name;

  final List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.category,
    required this.name,
    this.sets = const [],
  });

  Exercise copyWith({
    String? id,
    String? category,
    String? name,
    List<ExerciseSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      sets: sets ?? this.sets,
    );
  }
}