import 'package:flutter/cupertino.dart';

import '../../features/auth/screens/login_screen.dart';

class AnimatedTtgBorder extends StatelessWidget {
  final double progress;
  final double width;
  final double height;

  const AnimatedTtgBorder({
    super.key,
    required this.progress,
    this.width = 260,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TtgBorderPainter(progress),
      size: Size(width, height),
    );
  }
}

class _TtgBorderPainter extends CustomPainter {
  final double progress;

  _TtgBorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPrimaryRed
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;

    // 🔥 TTG BUTTON RADIUS
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(20), // 👈 wichtig!
    );

    final path = Path()..addRRect(rrect);

    // 🔥 Path extrahieren (für Animation)
    final metrics = path.computeMetrics().first;

    final extractPath = metrics.extractPath(
      0,
      metrics.length * progress,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}