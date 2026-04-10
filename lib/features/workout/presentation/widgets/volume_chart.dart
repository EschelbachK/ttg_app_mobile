import 'package:flutter/material.dart';

class VolumeChart extends StatelessWidget {
  final List<double> volumes;

  const VolumeChart({super.key, required this.volumes});

  @override
  Widget build(BuildContext context) {
    if (volumes.isEmpty) return const SizedBox.shrink();

    final max = volumes.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: volumes.map((v) {
          final double height =
          max == 0 ? 0.0 : ((v / max) * 120).toDouble();

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}