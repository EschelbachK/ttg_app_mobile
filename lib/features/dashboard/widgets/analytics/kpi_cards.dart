import 'package:flutter/material.dart';
import '../../domain/dashboard_data.dart';

class KpiCards extends StatelessWidget {
  final KPIs kpis;

  const KpiCards({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Row(
      children: [
        _item(t, "Total", kpis.totalVolume),
        const SizedBox(width: 8),
        _item(t, "Avg", kpis.avgVolume),
        const SizedBox(width: 8),
        _item(t, "Best", kpis.bestSession),
      ],
    );
  }

  Widget _item(ThemeData t, String title, double value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: t.textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                )),
            const SizedBox(height: 6),
            Text(
              value.toStringAsFixed(0),
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}