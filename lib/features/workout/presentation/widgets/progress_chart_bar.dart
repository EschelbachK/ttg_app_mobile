import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartBarData buildChartBar(
    List<FlSpot> spots,
    Color color, {
      int? highlightIndex,
      double? highlightValue,
    }) {
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    barWidth: 2.2,
    color: color,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, bar, index) {
        final isLast = highlightIndex != null && index == highlightIndex;
        final isPR =
            highlightValue != null && spot.y == highlightValue;

        if (isPR) {
          return FlDotCirclePainter(
            radius: 5,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: Colors.black,
          );
        }

        if (isLast) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 1,
            strokeColor: Colors.white,
          );
        }

        return FlDotCirclePainter(radius: 0);
      },
    ),
  );
}