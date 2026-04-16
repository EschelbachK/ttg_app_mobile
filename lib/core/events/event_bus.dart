import 'dart:async';

import 'app_event.dart';

class EventBus {
  final _controller = StreamController<AppEvent>.broadcast();

  void emit(AppEvent event) {
    _controller.add(event);
  }

  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((e) => e is T).cast<T>();
  }

  void dispose() {
    _controller.close();
  }
}