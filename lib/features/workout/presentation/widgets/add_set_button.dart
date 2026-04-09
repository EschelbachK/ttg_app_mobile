import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

class AddSetButton extends ConsumerWidget {
  final String exerciseId;

  const AddSetButton({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => _AddSetSheet(exerciseId: exerciseId),
        );
      },
      child: const Text('Add Set'),
    );
  }
}

class _AddSetSheet extends ConsumerStatefulWidget {
  final String exerciseId;

  const _AddSetSheet({required this.exerciseId});

  @override
  ConsumerState<_AddSetSheet> createState() => _AddSetSheetState();
}

class _AddSetSheetState extends ConsumerState<_AddSetSheet> {
  final weightCtrl = TextEditingController();
  final repsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: weightCtrl),
          TextField(controller: repsCtrl),
          ElevatedButton(
            onPressed: () async {
              final weight = double.parse(weightCtrl.text);
              final reps = int.parse(repsCtrl.text);

              await ref
                  .read(workoutProvider.notifier)
                  .addSet(widget.exerciseId, weight, reps);

              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}