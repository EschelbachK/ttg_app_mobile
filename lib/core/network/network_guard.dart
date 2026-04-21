import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_controller.dart';
class NetworkGuard {
  static bool isOffline(WidgetRef ref) {
    return ref.read(settingsProvider).offlineMode;
  }

  static void guard(WidgetRef ref) {
    if (isOffline(ref)) {
      throw Exception('Offline mode active');
    }
  }
}