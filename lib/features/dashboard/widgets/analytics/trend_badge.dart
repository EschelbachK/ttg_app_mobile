import 'package:flutter/material.dart';
import '../../domain/dashboard_data.dart';

class TrendBadge extends StatelessWidget {
  final TrendDirection trend;

  const TrendBadge({
    super.key,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (trend) {
      case TrendDirection.up:
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case TrendDirection.down:
        icon = Icons.trending_down;
        color = Colors.red;
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color),
    );
  }
}