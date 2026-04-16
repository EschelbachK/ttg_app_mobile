import 'package:flutter/material.dart';
import '../../domain/dashboard_data.dart';

class KpiCards extends StatelessWidget {
  final KPIs kpis;

  const KpiCards({
    super.key,
    required this.kpis,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _card("Total", kpis.totalVolume.toStringAsFixed(0))),
        const SizedBox(width: 8),
        Expanded(child: _card("Avg", kpis.avgVolume.toStringAsFixed(0))),
        const SizedBox(width: 8),
        Expanded(child: _card("Best", kpis.bestSession.toStringAsFixed(0))),
      ],
    );
  }

  Widget _card(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}