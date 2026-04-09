class MotivationBadge {
  final String name;
  final String description;
  final DateTime achievedAt;

  MotivationBadge({required this.name, required this.description, DateTime? achievedAt})
      : achievedAt = achievedAt ?? DateTime.now();
}