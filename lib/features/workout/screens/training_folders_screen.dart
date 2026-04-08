import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/app_layout.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_tile.dart';

class TrainingFoldersScreen extends ConsumerWidget {
  final String planId;

  const TrainingFoldersScreen({
    super.key,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider(planId));

    return AppLayout(
      title: 'Muskelgruppen',
      child: foldersAsync.when(
        data: (folders) => folders.isEmpty
            ? const Center(child: Text('Keine Muskelgruppen'))
            : ListView(
          children: folders
              .map((f) => WorkoutTile(
            title: f.name,
            onTap: () => context.go(
              '/workout/folders/${f.id}/exercises?planId=$planId',
            ),
          ))
              .toList(),
        ),
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }
}