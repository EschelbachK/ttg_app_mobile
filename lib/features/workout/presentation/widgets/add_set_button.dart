import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import 'add_set_cta.dart';

const kPrimaryRed = Color(0xFFE10600);

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
    final controller = ref.read(workoutProvider.notifier);

    return AddSetCTA(
      onTap: () {
        controller.addSet(
          exerciseId,
          suggestedWeight ?? 0,
          suggestedReps ?? 0,
        );
      },
    );
  }
}