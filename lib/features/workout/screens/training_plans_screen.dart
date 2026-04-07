import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';
import '../providers/workout_providers.dart';

class TrainingPlansScreen extends ConsumerWidget {
  final String planId;

  const TrainingPlansScreen({
    super.key,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider(planId));

    return AppLayout(
      title: 'Muskelgruppen',
      child: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return const Center(child: Text('Keine Muskelgruppen'));
          }

          return ListView.builder(
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];

              return ListTile(
                title: Text(folder.name),
                onTap: () => context.go(
                  '/workout/folders/${folder.id}/exercises?planId=$planId',
                ),
              );
            },
          );
        },
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }
}