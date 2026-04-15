import 'package:flutter/material.dart';

class MuscleHeatmapGrid extends StatelessWidget {
  final Map<String, double> data;

  const MuscleHeatmapGrid({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entries.map((e) {
        final intensity = (e.value / 1000).clamp(0.1, 1.0);

        return Container(
          width: 110,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(intensity),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            e.key,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}