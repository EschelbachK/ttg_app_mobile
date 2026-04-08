import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/app_layout.dart';
import '../providers/workout_providers.dart';
import '../widgets/workout_tile.dart';

class TrainingPlansScreen extends ConsumerWidget {
  const TrainingPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(trainingPlansProvider);

    return AppLayout(
      title: 'Workout',
      child: async.when(
        data: (plans) => plans.isEmpty
            ? const Center(child: Text('Keine Trainingspläne'))
            : ListView(
          children: plans
              .map((p) => WorkoutTile(
            title: p.name,
            onTap: () =>
                context.go('/workout/plans/${p.id}'),
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