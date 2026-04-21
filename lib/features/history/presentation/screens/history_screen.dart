import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../workout/application/workout_history_store.dart';
import '../../../workout/presentation/widgets/progress_chart.dart';
import '../widgets/history_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(workoutHistoryStoreProvider.notifier);
    final sessions = store.sessions;
    final entries = store.entries;

    final t = Theme.of(context);

    final exercise =
    entries.isNotEmpty ? entries.first.exerciseName : null;

    final filtered = exercise == null
        ? <dynamic>[]
        : entries.where((e) => e.exerciseName == exercise).toList();

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      body: SafeArea(
        child: sessions.isEmpty
            ? const _Empty()
            : ListView(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            ProgressChart(history: filtered),
            const SizedBox(height: 20),
            ...sessions.map((s) => HistoryTile(session: s)),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Center(
      child: Text(
        'Noch keine Workouts vorhanden',
        style: t.textTheme.bodyMedium?.copyWith(
          color: Colors.white54,
        ),
      ),
    );
  }
}