import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/app_layout.dart';
import '../providers/workout_providers.dart';

class TrainingSetScreen extends ConsumerWidget {
  final String exerciseId;

  const TrainingSetScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(setsProvider(exerciseId));

    return AppLayout(
      title: 'Sets',
      child: setsAsync.when(
        data: (sets) {
          if (sets.isEmpty) {
            return const Center(child: Text('Keine Sets'));
          }

          return ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final set = sets[index];

              return ListTile(
                title: Text('${set.reps} reps • ${set.weight} kg'),
                trailing: Checkbox(
                  value: set.completed,
                  onChanged: (_) async {
                    final api = ref.read(workoutApiServiceProvider);

                    await api.updateSet(
                      exerciseId,
                      set.id,
                      set.reps,
                      set.weight,
                      !set.completed,
                    );

                    ref.invalidate(setsProvider(exerciseId));
                  },
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