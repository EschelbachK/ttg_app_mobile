import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/set_entry.dart';
import '../providers/workout_providers.dart';

class TrainingSetScreen extends ConsumerWidget {
  final String exerciseId;
  final String exerciseName;

  const TrainingSetScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(setsProvider(exerciseId));

    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: setsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Error: $err')),
        data: (sets) =>
            _SetList(sets: sets, exerciseId: exerciseId),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final repsCtrl = TextEditingController();
    final weightCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Satz hinzufügen"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsCtrl,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: "Wiederholungen"),
            ),
            TextField(
              controller: weightCtrl,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: "Gewicht"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () async {
              final reps =
                  int.tryParse(repsCtrl.text) ?? 0;
              final weight =
                  double.tryParse(weightCtrl.text) ?? 0;

              final api =
              ref.read(workoutApiServiceProvider);

              await api.createSet(
                  exerciseId, reps, weight);

              ref.invalidate(setsProvider(exerciseId));

              Navigator.pop(context);
            },
            child: const Text("Erstellen"),
          )
        ],
      ),
    );
  }
}

class _SetList extends ConsumerWidget {
  final List<SetEntry> sets;
  final String exerciseId;

  const _SetList({
    required this.sets,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sets.isEmpty) {
      return const Center(
        child: Text("Keine Sätze vorhanden"),
      );
    }

    return ListView.builder(
      itemCount: sets.length,
      itemBuilder: (context, index) {
        final set = sets[index];

        return ListTile(
          title: Text(
              "${set.reps} Wdh • ${set.weight} kg"),
          trailing: Checkbox(
            value: set.completed,
            onChanged: (value) async {
              final api =
              ref.read(workoutApiServiceProvider);

              await api.updateSet(
                exerciseId,
                set.id,
                set.reps,
                set.weight,
                value ?? false,
              );

              ref.invalidate(setsProvider(exerciseId));
            },
          ),
        );
      },
    );
  }
}