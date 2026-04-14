import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutKpiSection extends StatelessWidget {
  final double volume;
  final double avgWeight;
  final int reps;
  final bool improving;

  const WorkoutKpiSection({
    super.key,
    required this.volume,
    required this.avgWeight,
    required this.reps,
    required this.improving,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _card('Volumen', '$volume KG', true)),
            const SizedBox(width: 12),
            Expanded(child: _card('Ø Gewicht', avgWeight.toString())),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _card('Wiederholungen', reps.toString())),
            const SizedBox(width: 12),
            Expanded(child: _trendCard(improving)),
          ],
        ),
      ],
    );
  }

  Widget _card(String title, String value, [bool highlight = false]) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: highlight ? kPrimaryRed : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendCard(bool improving) {
    final color = improving ? Colors.green : Colors.red;
    final icon = improving ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Trend', style: TextStyle(color: Colors.white54)),
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                improving ? 'STEIGEND' : 'FALLEND',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}