import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import 'reps_input_stepper.dart';
import 'weight_input_stepper.dart';
import 'swipe_to_delete_wrapper.dart';

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

    return SwipeToDeleteWrapper(
      onDelete: () {
        controller.updateSet(
          exerciseId: exerciseId,
          setId: setId,
          completed: false,
          weight: 0,
          reps: 0,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text('#${index + 1}'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WeightInputStepper(
                value: weight,
                onChanged: (v) => update(w: v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RepsInputStepper(
                value: reps,
                onChanged: (v) => update(r: v),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => update(c: !completed),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: completed ? Colors.green : Colors.transparent,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: completed
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}