import 'dart:ui';
import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutStartOverlay extends StatefulWidget {
  final VoidCallback onFinish;

  const WorkoutStartOverlay({super.key, required this.onFinish});

  @override
  State<WorkoutStartOverlay> createState() => _WorkoutStartOverlayState();
}

class _WorkoutStartOverlayState extends State<WorkoutStartOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _main;
  late final AnimationController _pulse;
  late final AnimationController _burst;

  int _index = 0;
  bool _running = true;

  static const _steps = ['TRAIN', '2', 'GAIN'];

  @override
  void initState() {
    super.initState();

    _main = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _burst = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _run();
  }

  Future<void> _run() async {
    for (var i = 0; i < _steps.length; i++) {
      if (!_running || !mounted) return;

      setState(() => _index = i);

      if (_steps[i] == 'GAIN') {
        _burst.forward(from: 0);
      }

      _main.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 850));
    }

    if (!_running || !mounted) return;
    widget.onFinish();
  }

  @override
  void dispose() {
    _running = false;
    _main.dispose();
    _pulse.dispose();
    _burst.dispose();
    super.dispose();
  }

  double safe(double v) => v.clamp(0.0, 1.0);

  Widget _ring(double pulse, int index) {
    final isGain = index == 2;
    final scale = 1 + pulse * 0.08;
    final opacity = (0.45 + pulse * 0.35).clamp(0.0, 1.0);

    return Transform.scale(
      scale: scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryRed.withOpacity(
                    (0.15 + pulse * 0.2).clamp(0.0, 1.0),
                  ),
                  blurRadius: 50,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: kPrimaryRed.withOpacity(opacity),
                width: isGain ? 4 : 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = _steps[_index];

    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.65),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_main, _pulse, _burst]),
              builder: (_, __) {
                final t = Curves.easeOut.transform(_main.value);
                final baseScale = 0.88 + t * 0.14;

                final pulse =
                Curves.easeInOut.transform(_pulse.value);

                final burst =
                Curves.easeOut.transform(_burst.value);

                final totalScale =
                    baseScale * (1 + pulse * 0.05) * (1 + burst * 0.18);

                return Transform.scale(
                  scale: totalScale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _ring(pulse, _index),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(140),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 16, sigmaY: 16),
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(140),
                              color:
                              Colors.white.withOpacity(0.035),
                              border: Border.all(
                                color: Colors.white
                                    .withOpacity(0.05),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration:
                        const Duration(milliseconds: 220),
                        child: Text(
                          text,
                          key: ValueKey(text),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: text == '2' ? 78 : 50,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                            height: 1,
                            shadows: [
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.7),
                                blurRadius: 25,
                              ),
                              if (_index == 2)
                                Shadow(
                                  color: kPrimaryRed
                                      .withOpacity(0.45),
                                  blurRadius: 28,
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (_index == 2)
                        Transform.scale(
                          scale: 1 + burst * 0.25,
                          child: Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kPrimaryRed.withOpacity(
                                  safe(0.5 - burst * 0.5),
                                ),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
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