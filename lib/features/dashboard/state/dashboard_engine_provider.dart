import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workout/application/progress_analytics_engine.dart';
import '../../workout/application/workout_history_store.dart';

final progressAnalyticsProvider = Provider<ProgressAnalyticsEngine>((ref) {
  final history = ref.watch(workoutHistoryStoreProvider);
  return ProgressAnalyticsEngine(history);
});