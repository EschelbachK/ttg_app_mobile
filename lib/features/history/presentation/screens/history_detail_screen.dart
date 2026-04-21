import 'package:flutter/material.dart';
import '../../../workout/domain/workout_session.dart';
import '../widgets/history_exercise_block.dart';

class HistoryDetailScreen extends StatelessWidget {
  final WorkoutSession session;

  const HistoryDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _date(session.startedAt),
            style: t.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),

          ...session.groups.expand(
                (g) => g.exercises.map(
                  (e) => HistoryExerciseBlock(exercise: e),
            ),
          ),
        ],
      ),
    );
  }

  String _date(DateTime d) =>
      '${d.day}.${d.month}.${d.year}';
}