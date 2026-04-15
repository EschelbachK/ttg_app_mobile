import 'package:flutter/material.dart';

class SessionCompareCard extends StatelessWidget {
  final double last;
  final double previous;

  const SessionCompareCard({
    super.key,
    required this.last,
    required this.previous,
  });

  @override
  Widget build(BuildContext context) {
    final diff = last - previous;
    final percent = previous == 0 ? 0 : (diff / previous) * 100;

    final improved = diff >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SESSION COMPARISON",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),

          Text(
            "${last.toStringAsFixed(0)} kg",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "${improved ? '+' : ''}${percent.toStringAsFixed(1)} %",
            style: TextStyle(
              color: improved ? Colors.green : Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}