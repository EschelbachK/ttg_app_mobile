import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/events/event_bus_provider.dart';
import '../../../core/events/workout_events.dart';
import '../../../core/audio/sound_provider.dart';
import '../../../core/haptics/haptic_provider.dart';
import '../../../core/settings/settings_controller.dart';

final soundListenerProvider = Provider((ref) {
  final bus = ref.read(eventBusProvider);
  final sound = ref.read(soundProvider);
  final haptic = ref.read(hapticProvider);

  void handle(bool enabled, void Function() action) {
    if (enabled) action();
  }

  bus.on<TimerTickEvent>().listen((e) {
    final enabled = ref.read(settingsProvider).soundEnabled;
    if (e.seconds <= 3 && e.seconds > 0) {
      handle(enabled, () {
        sound.playBeep();
        haptic.light();
      });
    }
  });

  bus.on<RestFinishedEvent>().listen((_) {
    handle(ref.read(settingsProvider).soundEnabled, () {
      sound.playFinish();
      haptic.heavy();
    });
  });
});