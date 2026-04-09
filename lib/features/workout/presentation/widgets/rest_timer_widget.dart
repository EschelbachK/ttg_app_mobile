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
    _start();
  }

  void _start() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining <= 1) {
        timer?.cancel();
        setState(() => remaining = 0);
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
    final double progress =
    widget.seconds == 0 ? 0.0 : remaining / widget.seconds;

    return Row(
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(value: progress),
        ),
        const SizedBox(width: 8),
        Text(remaining == 0 ? 'Done' : '$remaining s'),
      ],
    );
  }
}