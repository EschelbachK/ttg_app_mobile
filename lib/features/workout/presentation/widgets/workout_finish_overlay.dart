import 'dart:ui';
import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutFinishOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onDone;

  const WorkoutFinishOverlay({
    super.key,
    required this.message,
    required this.onDone,
  });

  @override
  State<WorkoutFinishOverlay> createState() =>
      _WorkoutFinishOverlayState();
}

class _WorkoutFinishOverlayState extends State<WorkoutFinishOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final t = Curves.easeOut.transform(_controller.value);
                final scale = 0.85 + (t * 0.15);
                final opacity = t;

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryRed.withOpacity(0.6),
                                blurRadius: 50,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'WORKOUT ABGESCHLOSSEN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}