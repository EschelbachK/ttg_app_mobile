import 'package:flutter/material.dart';
import '../../../workout/domain/workout_history_entry.dart';

class HistoryTile extends StatelessWidget {
  final List<WorkoutHistoryEntry> session;

  const HistoryTile({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final date = session.first.date;

    final exercises = session.map((e) => e.exerciseName).toSet().length;
    final sets = session.length;

    final volume = session.fold<double>(
      0,
          (sum, e) => sum + (e.weight * e.reps),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(date),
            style: t.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$exercises Übungen • $sets Sets',
            style: t.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Volumen: ${volume.toStringAsFixed(0)} kg',
            style: t.textTheme.bodySmall?.copyWith(
              color: t.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}.${d.month}.${d.year}';
  }
}