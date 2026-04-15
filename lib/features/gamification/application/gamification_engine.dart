import '../domain/gamification_state.dart';

class GamificationEngine {
  GamificationState addWorkoutXP(GamificationState state, int sets) {
    final gainedXP = sets * 10;

    final newXP = state.xp + gainedXP;
    final newLevel = (newXP / 200).floor() + 1;

    return state.copyWith(
      xp: newXP,
      level: newLevel,
    );
  }

  GamificationState updateStreak(GamificationState state, bool trainedToday) {
    final streak = trainedToday ? state.streak + 1 : 0;

    return state.copyWith(streak: streak);
  }

  List<String> checkBadges(GamificationState state) {
    final badges = [...state.badges];

    if (state.streak >= 3 && !badges.contains("Consistency")) {
      badges.add("Consistency");
    }

    if (state.level >= 5 && !badges.contains("Rising Athlete")) {
      badges.add("Rising Athlete");
    }

    return badges;
  }
}