import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_controller.dart';

class NetworkGuard {
  static bool isOffline(WidgetRef ref) {
    return ref.watch(settingsProvider).offlineMode;
  }

  static void guard(WidgetRef ref) {
    if (isOffline(ref)) {
      throw OfflineException();
    }
  }
}

class OfflineException implements Exception {
  @override
  String toString() => 'Offline mode active';
}