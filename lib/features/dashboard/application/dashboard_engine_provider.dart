import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workout/application/workout_history_store.dart';
import 'dashboard_engine.dart';

final dashboardEngineProvider = Provider<DashboardEngine>((ref) {
  final store = ref.watch(workoutHistoryStoreProvider);

  return DashboardEngine(store);
});