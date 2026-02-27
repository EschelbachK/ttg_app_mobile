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
      appBar: AppBar(
        title: Text(exerciseName),
      ),
      body: setsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error: $err')),
        data: (sets) =>
            _SetList(sets: sets, exerciseId: exerciseId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showCreateDialog(context, ref, exerciseId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context,
      WidgetRef ref,
      String exerciseId) async {
    final repsController = TextEditingController();
    final weightController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Set'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Reps'),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Weight'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final reps =
                    int.tryParse(repsController.text) ?? 0;
                final weight =
                    double.tryParse(weightController.text) ?? 0;

                final api =
                ref.read(workoutApiServiceProvider);

                await api.createSet(
                    exerciseId, reps, weight);

                ref.invalidate(
                    setsProvider(exerciseId));

                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
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
        child: Text('No sets yet.'),
      );
    }

    return ListView.builder(
      itemCount: sets.length,
      itemBuilder: (context, index) {
        final set = sets[index];

        return Dismissible(
          key: ValueKey(set.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding:
            const EdgeInsets.symmetric(horizontal: 20),
            child:
            const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) async {
            final api =
            ref.read(workoutApiServiceProvider);

            await api.deleteSet(
                exerciseId, set.id);

            ref.invalidate(
                setsProvider(exerciseId));
          },
          child: ListTile(
            title: Text(
                '${set.reps} reps - ${set.weight} kg'),
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

                ref.invalidate(
                    setsProvider(exerciseId));
              },
            ),
          ),
        );
      },
    );
  }
}