import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workout/application/workout_history_store.dart';
import 'ai_coach_engine.dart';

final aiCoachProvider = Provider<AICoachEngine>((ref) {
  final history = ref.watch(workoutHistoryStoreProvider);
  return AICoachEngine(history);
});