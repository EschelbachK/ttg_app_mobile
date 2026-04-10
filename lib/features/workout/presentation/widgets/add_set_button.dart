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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => _AddSetSheet(
              exerciseId: exerciseId,
              suggestedWeight: suggestedWeight,
              suggestedReps: suggestedReps,
            ),
          );
        },
        child: const Text('Set hinzufügen'),
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
  void dispose() {
    weightCtrl.dispose();
    repsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final controller = ref.read(workoutProvider.notifier);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Neuer Satz',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: weightCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Gewicht',
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: repsCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Wiederholungen',
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final weight = double.tryParse(weightCtrl.text);
                final reps = int.tryParse(repsCtrl.text);
                if (weight == null || reps == null) return;

                await controller.addSet(widget.exerciseId, weight, reps);

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}