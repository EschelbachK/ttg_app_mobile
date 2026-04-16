import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/application/history_service.dart';
import 'gamification_engine.dart';

final gamificationProvider = Provider<GamificationEngine>((ref) {
  final historyService = ref.read(historyServiceProvider);
  return GamificationEngine(historyService);
});