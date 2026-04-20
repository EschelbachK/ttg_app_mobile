import 'dart:math';
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
  State<WorkoutFinishOverlay> createState() => _WorkoutFinishOverlayState();
}

class _WorkoutFinishOverlayState extends State<WorkoutFinishOverlay>
    with TickerProviderStateMixin {
  late final AnimationController c;
  late final AnimationController pulse;

  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..forward();
    pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
  }

  @override
  void dispose() {
    c.dispose();
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muscles = widget.completedMuscles;

    return Positioned.fill(
      child: Stack(children: [
        Positioned.fill(
          child: Image.asset("assets/images/dashboard_bg.png", fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.75)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: AnimatedBuilder(
              animation: c,
              builder: (_, __) {
                final value = c.value;

                return Stack(children: [
                  if (value > 0.88) const _Confetti(),
                  Align(alignment: Alignment.center, child: _content(muscles, value)),
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }

  Widget _content(List<String> muscles, double value) {
    final t = Curves.easeOutCubic.transform(value);
    final titleY = Tween(begin: 20.0, end: -40.0).transform((t.clamp(0.0, 0.4) / 0.4));
    final offsetY = 36.0 + muscles.length.toDouble();

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Transform.translate(
          offset: Offset(0, titleY),
          child: Column(children: [
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
          ]),
        ),
        const SizedBox(height: 2),
        ...List.generate(muscles.length, (i) {
          final step = 0.5 / muscles.length;
          final start = 0.35 + (i * step);
          final end = start + step;
          final progress = ((value - start) / (end - start)).clamp(0.0, 1.0);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: muscles.length > 4 ? 4 : 6),
            child: _Row(text: muscles[i], progress: progress),
          );
        }),
        const SizedBox(height: 40),
        Opacity(
          opacity: value > 0.85 ? 1 : 0,
          child: _Button(onTap: widget.onDone),
        ),
      ]),
    );
  }
}

class _Confetti extends StatefulWidget {
  const _Confetti({super.key});

  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;

  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) => RepaintBoundary(
        child: CustomPaint(
          painter: _ConfettiPainter(c.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double t;
  final Random r = Random(7);

  _ConfettiPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    if (t > 0.85) return;

    final center = Offset(size.width / 2, size.height * 0.28);
    const particles = 80;

    for (int i = 0; i < particles; i++) {
      final seed = i * 17;
      final angle = (i / particles) * pi * 2;
      final speed = 300 + (seed % 60) * 4;

      final dx = cos(angle) * speed * t;
      final dy = sin(angle) * speed * t + (260 * t * t);

      final x = center.dx + dx;
      final y = center.dy + dy;

      final opacity = (1 - t).clamp(0.0, 1.0);

      const colors = [
        Colors.amberAccent,
        Colors.orangeAccent,
        Colors.white,
        kPrimaryRed,
      ];

      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      final trailPaint = Paint()
        ..shader = LinearGradient(
          colors: [color.withOpacity(0), color.withOpacity(0.7)],
        ).createShader(Rect.fromPoints(
          Offset(x, y),
          Offset(x - dx * 0.1, y - dy * 0.1),
        ))
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x - dx * 0.1, y - dy * 0.1),
        Offset(x, y),
        trailPaint,
      );

      canvas.drawCircle(Offset(x, y), 2.5 + (seed % 2), paint);

      if (i % 3 == 0) {
        canvas.drawCircle(
          Offset(x + sin(seed + t * 10) * 3, y + cos(seed + t * 10) * 3),
          1.5,
          Paint()..color = Colors.white.withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
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
          child: Stack(alignment: Alignment.center, children: [
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
              child: const Icon(Icons.check, color: Colors.white, size: 54),
            ),
          ]),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  final String text;
  final double progress;

  const _Row({required this.text, required this.progress});

  @override
  Widget build(BuildContext context) {
    const borderWidth = 260.0;
    const totalWidth = 320.0;
    const rightPadding = (totalWidth - borderWidth) / 2;

    final textEase = Curves.easeOutCubic.transform((progress / 0.4).clamp(0, 1));
    final borderEase = Curves.easeInOut.transform(((progress - 0.4) / 0.35).clamp(0, 1));
    final checkEase = Curves.easeOut.transform(((progress - 0.75) / 0.25).clamp(0, 1));

    return SizedBox(
      width: totalWidth,
      height: 50,
      child: Stack(alignment: Alignment.center, children: [
        if (borderEase > 0)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: borderWidth,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  border: Border.all(
                    color: kPrimaryRed.withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        if (borderEase > 0)
          AnimatedTtgBorder(
            progress: borderEase,
            width: borderWidth,
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
          right: rightPadding + 18,
          child: Transform.translate(
            offset: Offset((1 - checkEase) * 40, 0),
            child: Opacity(
              opacity: checkEase,
              child: const Icon(Icons.check, size: 20, color: Colors.white),
            ),
          ),
        ),
      ]),
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

  void _press(bool down) => setState(() => _scale = down ? 0.96 : 1);

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