import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/ui/animated_ttg_border.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutFinishOverlay extends StatefulWidget {
  final VoidCallback onDone;
  final List<String> completedMuscles;

  const WorkoutFinishOverlay({
    super.key,
    required this.onDone,
    required this.completedMuscles,
  });

  @override
  State<WorkoutFinishOverlay> createState() =>
      _WorkoutFinishOverlayState();
}

class _WorkoutFinishOverlayState extends State<WorkoutFinishOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward();

    _autoClose();
  }

  void _autoClose() async {
    await Future.delayed(const Duration(milliseconds: 5000));

    if (!_disposed && mounted) {
      widget.onDone();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muscles = widget.completedMuscles;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Center(
            child: AnimatedBuilder(
              animation: c,
              builder: (_, __) {
                final t = Curves.easeInOutCubic.transform(c.value);

                final titleY = Tween(begin: 0.0, end: -80.0)
                    .transform((t.clamp(0.0, 0.4) / 0.4));

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(0, titleY),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryRed.withOpacity(0.7),
                                  blurRadius: 60,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'WORKOUT ABGESCHLOSSEN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    ...List.generate(muscles.length, (i) {
                      final start = 0.35 + (i * 0.22);
                      final end = start + 0.45;

                      final progress =
                      ((c.value - start) / (end - start))
                          .clamp(0.0, 1.0);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: _Row(
                          text: muscles[i],
                          progress: progress,
                        ),
                      );
                    }),

                    const SizedBox(height: 50),

                    Opacity(
                      opacity: c.value > 0.85 ? 1 : 0,
                      child: _Button(onTap: widget.onDone),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String text;
  final double progress;

  const _Row({
    required this.text,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final textPhase = (progress / 0.4).clamp(0.0, 1.0);
    final borderPhase = ((progress - 0.4) / 0.35).clamp(0.0, 1.0);
    final checkPhase = ((progress - 0.75) / 0.25).clamp(0.0, 1.0);

    final textEase = Curves.easeOutCubic.transform(textPhase);
    final borderEase = Curves.easeInOut.transform(borderPhase);
    final checkEase = Curves.easeOutCubic.transform(checkPhase);

    return SizedBox(
      width: 320,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (borderEase > 0)
            AnimatedTtgBorder(
              progress: borderEase,
              width: 260,
              height: 36,
            ),

          Transform.translate(
            offset: Offset((1 - textEase) * 160, 0),
            child: Opacity(
              opacity: textEase,
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),

          Positioned(
            right: 30,
            top: 0,
            bottom: 0,
            child: Transform.translate(
              offset: Offset((1 - checkEase) * 60, 0),
              child: Opacity(
                opacity: checkEase,
                child: const Icon(
                  Icons.check,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final VoidCallback onTap;

  const _Button({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: kPrimaryRed,
          boxShadow: [
            BoxShadow(
              color: kPrimaryRed.withOpacity(0.6),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'ZUR STATISTIK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}