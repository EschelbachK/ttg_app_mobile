import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/events/event_bus_provider.dart';
import '../../../core/events/workout_events.dart';
import 'gamification_provider.dart';

final gamificationListenerProvider = Provider<void>((ref) {
  final bus = ref.read(eventBusProvider);
  final game = ref.read(gamificationProvider);

  bus.on<WorkoutFinishedEvent>().listen((event) {
    game.totalXP();
    game.currentStreak();
  });
});