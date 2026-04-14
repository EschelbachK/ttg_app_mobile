import 'dart:async';

class RestTimer {
  Timer? _timer;
  int _seconds = 0;
  bool _visible = false;

  int get seconds => _seconds;
  bool get visible => _visible;

  void start({
    required int seconds,
    required void Function() onTick,
    required void Function() onDone,
  }) {
    _timer?.cancel();
    _seconds = seconds;
    _visible = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds-- <= 0) {
        t.cancel();
        _seconds = 0;
        _visible = false;
        onDone();
      }
      onTick();
    });
  }

  void stop(void Function() onStop) {
    _timer?.cancel();
    _seconds = 0;
    _visible = false;
    onStop();
  }

  void dispose() {
    _timer?.cancel();
  }
}