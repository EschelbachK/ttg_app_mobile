import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        controller.deleteSet(exerciseId, setId);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: completed ? Colors.white.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: completed ? Colors.green : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
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
              onTap: () {
                HapticFeedback.mediumImpact();
                update(c: !completed);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: completed ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: completed ? Colors.green : Colors.white24,
                  ),
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