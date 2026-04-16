import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/events/event_bus_provider.dart';
import '../../../core/events/workout_events.dart';
import '../../history/application/history_service.dart';
import '../domain/motivation/motivation_event.dart';
import 'motivation_provider.dart';

final motivationListenerProvider = Provider<void>((ref) {
  final bus = ref.read(eventBusProvider);
  final motivator = ref.read(motivationProvider.notifier);
  final historyService = ref.read(historyServiceProvider);

  final sub = bus.on<WorkoutFinishedEvent>().listen((event) {
    final history = historyService.getAll();
    if (history.isEmpty) return;

    final last = history.last;
    final prev = history.length > 1 ? history[history.length - 2] : null;

    motivator.evaluate(
      MotivationEvent(
        repsDiff: prev != null ? last.reps - prev.reps : 0,
        weightDiff: prev != null ? last.weight - prev.weight : 0,
        streakDays: motivator.engine.streak.streakCount,
        isComeback: motivator.engine.streak.streakCount == 1,
        totalWorkouts: history.length,
      ),
    );

    motivator.updateStreakFromSession(event.session);
  });

  ref.onDispose(sub.cancel);
});