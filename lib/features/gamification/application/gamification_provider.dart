import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/gamification_state.dart';
import 'gamification_engine.dart';

final gamificationProvider =
StateNotifierProvider<GamificationNotifier, GamificationState>(
      (ref) => GamificationNotifier(),
);

class GamificationNotifier extends StateNotifier<GamificationState> {
  final engine = GamificationEngine();

  GamificationNotifier() : super(const GamificationState());

  void addXP(int sets) {
    state = engine.addWorkoutXP(state, sets);
    state = state.copyWith(
      badges: engine.checkBadges(state),
    );
  }

  void updateStreak(bool trainedToday) {
    state = engine.updateStreak(state, trainedToday);
  }
}