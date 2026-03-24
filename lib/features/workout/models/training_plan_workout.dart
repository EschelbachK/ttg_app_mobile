class TrainingPlan {
  final String id;
  final String name;

  TrainingPlan({
    required this.id,
    required this.name,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['title'] ?? 'Unbenannt',
    );
  }
}