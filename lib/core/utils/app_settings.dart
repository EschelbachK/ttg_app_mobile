import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_controller.dart';

bool isSoundEnabled(WidgetRef ref) {
  return ref.read(settingsProvider).soundEnabled;
}