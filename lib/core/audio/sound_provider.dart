import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/application/settings_provider.dart';
import 'sound_service.dart';

final soundProvider = Provider<SoundService>((ref) {
  final s = ref.watch(settingsProvider);
  final service = SoundService();

  ref.onDispose(service.dispose);

  return _GuardedSoundService(service, s);
});

class _GuardedSoundService extends SoundService {
  final SoundService _s;
  final dynamic settings;

  _GuardedSoundService(this._s, this.settings);

  bool get _enabled => settings.soundEnabled;

  @override
  Future<void> playBeep() async {
    if (!_enabled || !settings.countdownSound) return;
    await _s.playBeep();
  }

  @override
  Future<void> playStart() async {
    if (!_enabled || !settings.startSound) return;
    await _s.playStart();
  }

  @override
  Future<void> playFinish() async {
    if (!_enabled) return;
    await _s.playFinish();
  }

  @override
  Future<void> dispose() => _s.dispose();
}