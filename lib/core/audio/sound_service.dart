import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final _player = AudioPlayer();

  Future<void> playBeep() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/beep.mp3'));
  }

  Future<void> playFinish() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/finish.mp3'));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}