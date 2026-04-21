import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../workout/application/workout_history_store.dart';
import '../widgets/history_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions =
        ref.watch(workoutHistoryStoreProvider.notifier).sessions;

    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      body: SafeArea(
        child: sessions.isEmpty
            ? const _Empty()
            : ListView.builder(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: sessions.length,
          itemBuilder: (_, i) => HistoryTile(session: sessions[i]),
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