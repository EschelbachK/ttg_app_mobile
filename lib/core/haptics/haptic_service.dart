import 'package:flutter/services.dart';

class HapticService {
  static void _run(Future<void> Function() fn) {
    try {
      fn();
    } catch (_) {}
  }

  static void light() => _run(HapticFeedback.lightImpact);
  static void medium() => _run(HapticFeedback.mediumImpact);
  static void heavy() => _run(HapticFeedback.heavyImpact);
  static void success() => _run(HapticFeedback.selectionClick);
}