import 'dart:async';
import 'dart:ui';

class RestTimer {
  Timer? _timer;

  void start({
    required int seconds,
    required void Function(int secondsLeft) onTick,
    required VoidCallback onDone,
  }) {
    _timer?.cancel();

    int remaining = seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      remaining--;

      if (remaining <= 0) {
        t.cancel();
        onTick(0);
        onDone();
        return;
      }

      onTick(remaining);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _timer?.cancel();
  }
}