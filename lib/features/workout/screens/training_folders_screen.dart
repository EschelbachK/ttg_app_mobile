import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/app_layout.dart';
import '../state/workout_provider.dart';

class TrainingFoldersScreen extends ConsumerWidget {
  const TrainingFoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(trainingPlansProvider);

    return AppLayout(
      title: 'Workout',
      child: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Fehler beim Laden',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(
              child: Text('Keine Trainingspläne vorhanden'),
            );
          }

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];

              return ListTile(
                title: Text(plan.name),
                subtitle: Text('ID: ${plan.id}'),
                onTap: () {
                  // nächster Schritt später
                },
              );
            },
          );
        },
      ),
    );
  }
}