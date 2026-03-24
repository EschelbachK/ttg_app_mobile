class SetEntry {
  final String id;
  final int reps;
  final double weight;
  final bool completed;

  SetEntry({
    required this.id,
    required this.reps,
    required this.weight,
    required this.completed,
  });

  factory SetEntry.fromJson(Map<String, dynamic> json) {
    return SetEntry(
      id: json['id'],
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'completed': completed,
    };
  }
}