import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/workout/presentation/widgets/reps_input_stepper.dart';
import 'package:ttg_app_mobile/features/workout/presentation/widgets/weight_input_stepper.dart';
import '../../providers/workout_provider.dart';
import 'widgets/weight_input_stepper.dart';
import 'widgets/reps_input_stepper.dart';

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
        SizedBox(
          width: 120,
          child: WeightInputStepper(
            value: weight,
            onChanged: (v) => update(w: v),
          ),
        ),
        SizedBox(
          width: 120,
          child: RepsInputStepper(
            value: reps,
            onChanged: (v) => update(r: v),
          ),
        ),
        Checkbox(
          value: completed,
          onChanged: (val) => update(c: val ?? false),
        ),
      ],
    );
  }
}