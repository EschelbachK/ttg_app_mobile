import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_state.dart';

final soundProvider = Provider<SoundService>((ref) {
  final settings = ref.watch(settingsProvider);
  final service = SoundService(settings);

  ref.onDispose(service.dispose);

  return service;
});

class SoundService {
  final SettingsState settings;
  final _player = AudioPlayerWrapper();

  SoundService(this.settings);

  bool get _enabled => settings.soundEnabled;

  Future<void> _play(String path) async {
    await _player.stop();
    await _player.play(path);
  }

  Future<void> playBeep() async {
    if (!_enabled || !settings.countdownSound) return;
    await _play('sounds/beep.mp3');
  }

  Future<void> playStart() async {
    if (!_enabled || !settings.startSound) return;
    await _play('sounds/start.mp3');
  }

  Future<void> playFinish() async {
    if (!_enabled) return;
    await _play('sounds/finish.mp3');
  }

  Future<void> dispose() => _player.dispose();
}

class AudioPlayerWrapper {
  final _player = AudioPlayer();

  Future<void> play(String path) async {
    await _player.play(AssetSource(path));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}