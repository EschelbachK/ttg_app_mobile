import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_controller.dart';
import 'haptic_service.dart';

final hapticProvider = Provider<HapticController>((ref) {
  final enabled = ref.watch(settingsProvider).soundEnabled;
  return HapticController(enabled);
});

class HapticController {
  final bool enabled;

  const HapticController(this.enabled);

  void _run(void Function() fn) {
    if (enabled) fn();
  }

  void light() => _run(HapticService.light);
  void medium() => _run(HapticService.medium);
  void heavy() => _run(HapticService.heavy);
  void success() => _run(HapticService.success);
}