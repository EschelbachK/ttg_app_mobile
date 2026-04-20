import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/application/settings_provider.dart';

bool isSoundEnabled(WidgetRef ref) {
  return ref.read(settingsProvider).soundEnabled;
}