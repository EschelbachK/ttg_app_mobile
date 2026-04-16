import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/application/history_service.dart';
import 'ai_coach_engine.dart';

final aiCoachProvider = Provider<AICoachEngine>((ref) {
  final historyService = ref.read(historyServiceProvider);
  return AICoachEngine(historyService);
});