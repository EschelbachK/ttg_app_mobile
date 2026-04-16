import 'package:flutter/material.dart';

class PerformanceBlock extends StatelessWidget {
  final double current;
  final double previous;

  const PerformanceBlock({
    super.key,
    required this.current,
    required this.previous,
  });

  double _change() {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final change = _change();
    final positive = change >= 0;

    final mainText = previous == 0
        ? "Erstes Training abgeschlossen"
        : positive
        ? "+${change.toStringAsFixed(1)}% stärker"
        : "${change.toStringAsFixed(1)}% schwächer";

    final subText = previous == 0
        ? "Starker Start!"
        : positive
        ? "Volumen gesteigert"
        : "Fokus auf Erholung";

    final baseColor = positive
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            baseColor.withOpacity(0.18),
            Colors.black.withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: baseColor.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: -6,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor.withOpacity(0.12),
            ),
            child: Icon(
              positive ? Icons.trending_up : Icons.trending_down,
              color: baseColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainText,
                  style: TextStyle(
                    color: baseColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}