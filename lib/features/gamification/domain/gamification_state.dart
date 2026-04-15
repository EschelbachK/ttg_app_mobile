class GamificationState {
  final int xp;
  final int level;
  final int streak;
  final List<String> badges;

  const GamificationState({
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.badges = const [],
  });

  GamificationState copyWith({
    int? xp,
    int? level,
    int? streak,
    List<String>? badges,
  }) {
    return GamificationState(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
    );
  }
}