import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final _player = AudioPlayer();

  Future<void> _play(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  Future<void> playBeep() => _play('sounds/beep.mp3');

  Future<void> playFinish() => _play('sounds/finish.mp3');

  Future<void> playStart() => _play('sounds/start.mp3');

  Future<void> dispose() => _player.dispose();
}