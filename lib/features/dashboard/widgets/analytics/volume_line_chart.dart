import 'package:flutter/material.dart';

class VolumeLineChart extends StatelessWidget {
  final List<double> values;

  const VolumeLineChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(
        child: Text(
          "No data",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.asMap().entries.map((entry) {
          final index = entry.key;
          final v = entry.value;

          final height = maxValue == 0 ? 0.0 : (v / maxValue);

          final isLast = index == values.length - 1;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                height: 150 * height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: isLast
                        ? [
                      Colors.redAccent,
                      Colors.orangeAccent,
                    ]
                        : [
                      Colors.redAccent.withOpacity(0.7),
                      Colors.redAccent.withOpacity(0.3),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  boxShadow: isLast
                      ? [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 12,
                    ),
                  ]
                      : [],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}