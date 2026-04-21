import 'package:flutter/material.dart';
import '../../../workout/domain/workout_history_entry.dart';

class HistoryDetailScreen extends StatelessWidget {
  final List<WorkoutHistoryEntry> entries;

  const HistoryDetailScreen({super.key, required this.entries});

  factory HistoryDetailScreen.fromEntries(
      List<WorkoutHistoryEntry> entries) {
    return HistoryDetailScreen(entries: entries);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    final grouped = <String, List<WorkoutHistoryEntry>>{};
    for (final e in entries) {
      (grouped[e.exerciseName] ??= []).add(e);
    }

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      appBar: AppBar(title: const Text('Workout Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          final name = entry.key;
          final sets = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: t.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ...sets.map(
                      (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${s.reps} Wdh',
                          style: t.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${s.weight.toStringAsFixed(1)} kg',
                          style: t.textTheme.bodySmall?.copyWith(
                            color: t.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}