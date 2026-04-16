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
    with TickerProviderStateMixin {
  late final AnimationController c;
  late final AnimationController pulse;

  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _autoClose();
  }

  void _autoClose() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    if (!_disposed && mounted) widget.onDone();
  }

  @override
  void dispose() {
    _disposed = true;
    c.dispose();
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muscles = widget.completedMuscles;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.82),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: AnimatedBuilder(
                animation: c,
                builder: (_, __) {
                  final t = Curves.easeOutCubic.transform(c.value);

                  final titleY = Tween(begin: 30.0, end: -70.0)
                      .transform((t.clamp(0.0, 0.4) / 0.4));

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset: Offset(0, titleY),
                        child: Column(
                          children: [
                            _PremiumOrb(pulse: pulse),
                            const SizedBox(height: 18),
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
                        final baseStart = 0.35;
                        final available = 0.5;
                        final step = available / muscles.length;

                        final start = baseStart + (i * step);
                        final end = start + step;

                        final progress =
                        ((c.value - start) / (end - start))
                            .clamp(0.0, 1.0);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
      ),
    );
  }
}

class _PremiumOrb extends StatelessWidget {
  final AnimationController pulse;

  const _PremiumOrb({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) {
        final scale = 0.96 + (pulse.value * 0.08);

        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryRed.withOpacity(0.08),
                ),
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      kPrimaryRed.withOpacity(0.9),
                      kPrimaryRed.withOpacity(0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryRed.withOpacity(0.35),
                      blurRadius: 40,
                      spreadRadius: -6,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 54,
                ),
              ),
            ],
          ),
        );
      },
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
    final textEase =
    Curves.easeOutCubic.transform((progress / 0.4).clamp(0.0, 1.0));
    final borderEase =
    Curves.easeInOut.transform(((progress - 0.4) / 0.35).clamp(0.0, 1.0));
    final checkEase =
    Curves.easeOut.transform(((progress - 0.75) / 0.25).clamp(0.0, 1.0));

    return SizedBox(
      width: 320,
      height: 48,
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
            offset: Offset((1 - textEase) * 140, 0),
            child: Opacity(
              opacity: textEase,
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.2,
                ),
              ),
            ),
          ),

          Positioned(
            right: 26,
            child: Transform.translate(
              offset: Offset((1 - checkEase) * 50, 0),
              child: Opacity(
                opacity: checkEase,
                child: const Icon(
                  Icons.check,
                  size: 20,
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

class _Button extends StatefulWidget {
  final VoidCallback onTap;

  const _Button({required this.onTap});

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  double _scale = 1;

  void _press(bool down) {
    setState(() {
      _scale = down ? 0.96 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _press(true),
      onTapUp: (_) => _press(false),
      onTapCancel: () => _press(false),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: kPrimaryRed,
            boxShadow: [
              BoxShadow(
                color: kPrimaryRed.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 6),
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
      ),
    );
  }
}