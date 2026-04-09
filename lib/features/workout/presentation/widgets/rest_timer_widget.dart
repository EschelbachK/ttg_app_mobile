import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerWidget extends StatefulWidget {
  final int seconds;

  const RestTimerWidget({super.key, required this.seconds});

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  late int remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.seconds;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining == 0) {
        timer?.cancel();
      } else {
        setState(() => remaining--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$remaining s',
      style: const TextStyle(fontSize: 20),
    );
  }
}