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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _AddSetSheet(
              exerciseId: exerciseId,
              suggestedWeight: suggestedWeight,
              suggestedReps: suggestedReps,
            ),
          );
        },
        child: const Text('Add Set'),
      ),
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
  late final TextEditingController weightCtrl;
  late final TextEditingController repsCtrl;

  @override
  void initState() {
    super.initState();
    weightCtrl = TextEditingController(
      text: widget.suggestedWeight?.toStringAsFixed(1) ?? '',
    );
    repsCtrl = TextEditingController(
      text: widget.suggestedReps?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: weightCtrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Weight'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: repsCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Reps'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final weight = double.tryParse(weightCtrl.text);
                final reps = int.tryParse(repsCtrl.text);

                if (weight == null || reps == null) return;

                await ref
                    .read(workoutProvider.notifier)
                    .addSet(widget.exerciseId, weight, reps);

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}