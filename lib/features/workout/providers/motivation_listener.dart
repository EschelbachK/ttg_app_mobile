import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/core_sound_service_provider.dart';
import '../../../core/haptics/haptic_controller_provider.dart';
import '../../../core/events/core_event_bus_provider.dart';
import '../../../core/events/workout_session_events.dart';
import '../../../core/settings/settings_controller.dart';
import '../../history/application/history_service.dart';
import '../domain/motivation/motivation_event.dart';
import 'motivation_provider.dart';

final motivationListenerProvider = Provider<void>((ref) {
  final bus = ref.read(eventBusProvider);
  final motivator = ref.read(motivationProvider.notifier);
  final historyService = ref.read(historyServiceProvider);
  final sound = ref.read(soundProvider);
  final haptic = ref.read(hapticProvider);
  final settings = ref.read(settingsProvider);

  final sub1 = bus.on<WorkoutFinishedEvent>().listen((event) {
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

  final sub2 = bus.on<TimerTickEvent>().listen((event) {
    if (!settings.soundEnabled) return;

    if (event.seconds <= 3 && event.seconds > 0) {
      sound.playBeep();
      haptic.light(); // ✅ FIX
    }
  });

  final sub3 = bus.on<RestFinishedEvent>().listen((event) {
    if (!settings.soundEnabled) return;

    sound.playFinish();
    haptic.heavy(); // ✅ FIX
  });

  ref.onDispose(() {
    sub1.cancel();
    sub2.cancel();
    sub3.cancel();
  });
});