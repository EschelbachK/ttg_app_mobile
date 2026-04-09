import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerWidget extends StatefulWidget {
  final int seconds;

  const RestTimerWidget({
    super.key,
    required this.seconds,
  });

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

  double get progress => widget.seconds == 0 ? 0 : remaining / widget.seconds;

  @override
  Widget build(BuildContext context) {
    final isDone = remaining == 0;

    return Row(
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
              ),
              Text(
                '$remaining',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isDone ? 'Rest done' : 'Rest',
          style: TextStyle(
            fontSize: 14,
            color: isDone ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}