import 'package:flutter/material.dart';
import '../../domain/progress_insight.dart';
import 'ttg_glass_card.dart';

class InsightCard extends StatelessWidget {
  final ProgressInsight insight;

  const InsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return TtgGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(insight.message),
      ),
    );
  }
}