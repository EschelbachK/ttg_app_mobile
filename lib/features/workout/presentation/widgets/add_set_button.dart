import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

class AddSetButton extends ConsumerWidget {
  final String exerciseId;
  final double? suggestedWeight;
  final int? suggestedReps;

  const AddSetButton({
    super.key,
    required this.exerciseId,
    this.suggestedWeight,
    this.suggestedReps,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => _AddSetSheet(
            exerciseId: exerciseId,
            suggestedWeight: suggestedWeight,
            suggestedReps: suggestedReps,
          ),
        );
      },
      child: const Text('Add Set'),
    );
  }
}

class _AddSetSheet extends ConsumerStatefulWidget {
  final String exerciseId;
  final double? suggestedWeight;
  final int? suggestedReps;

  const _AddSetSheet({
    required this.exerciseId,
    this.suggestedWeight,
    this.suggestedReps,
  });

  @override
  ConsumerState<_AddSetSheet> createState() => _AddSetSheetState();
}

class _AddSetSheetState extends ConsumerState<_AddSetSheet> {
  late TextEditingController weightCtrl;
  late TextEditingController repsCtrl;

  @override
  void initState() {
    super.initState();
    weightCtrl = TextEditingController(
        text: widget.suggestedWeight?.toString() ?? '');
    repsCtrl =
        TextEditingController(text: widget.suggestedReps?.toString() ?? '');
  }

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