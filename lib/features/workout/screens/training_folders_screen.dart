import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';
import '../providers/workout_providers.dart';

class TrainingFoldersScreen extends ConsumerWidget {
  const TrainingFoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(trainingPlansProvider);

    return AppLayout(
      title: 'Workout',
      child: plansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text('Keine Trainingspläne'));
          }

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];

              return ListTile(
                title: Text(plan.name),
                onTap: () => context.go('/workout/plans/${plan.id}'),
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