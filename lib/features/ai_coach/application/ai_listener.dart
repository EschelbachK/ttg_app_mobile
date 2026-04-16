import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/events/event_bus_provider.dart';
import '../../../core/events/workout_events.dart';
import 'ai_coach_provider.dart';

final aiListenerProvider = Provider<void>((ref) {
  final bus = ref.read(eventBusProvider);
  final ai = ref.read(aiCoachProvider);

  bus.on<WorkoutFinishedEvent>().listen((event) {
    ai.fatigueScore();
    ai.coachMessage();
  });
});