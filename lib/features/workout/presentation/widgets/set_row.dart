import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

class SetRow extends ConsumerWidget {
  final int index;
  final String exerciseId;
  final String setId;
  final double weight;
  final int reps;
  final bool completed;

  const SetRow({
    super.key,
    required this.index,
    required this.exerciseId,
    required this.setId,
    required this.weight,
    required this.reps,
    required this.completed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutProvider.notifier);

    void update({double? w, int? r, bool? c}) {
      controller.updateSet(
        exerciseId: exerciseId,
        setId: setId,
        weight: w,
        reps: r,
        completed: c,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('#${index + 1}'),
        Row(
          children: [
            IconButton(
              onPressed: () => update(w: weight - 2.5),
              icon: const Icon(Icons.remove),
            ),
            Text('${weight.toStringAsFixed(1)} kg'),
            IconButton(
              onPressed: () => update(w: weight + 2.5),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => update(r: reps - 1),
              icon: const Icon(Icons.remove),
            ),
            Text('$reps reps'),
            IconButton(
              onPressed: () => update(r: reps + 1),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Checkbox(
          value: completed,
          onChanged: (val) => update(c: val),
        ),
      ],
    );
  }
}