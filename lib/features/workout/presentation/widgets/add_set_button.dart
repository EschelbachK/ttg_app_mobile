import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

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

    return Center(
      child: GestureDetector(
        onTap: () {
          controller.addSet(
            exerciseId,
            suggestedWeight ?? 0,
            suggestedReps ?? 0,
          );
        },
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kPrimaryRed.withOpacity(0.6)),
              gradient: LinearGradient(
                colors: [
                  kPrimaryRed.withOpacity(0.15),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: kPrimaryRed, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'SATZ HINZUFÜGEN',
                    style: TextStyle(
                      color: kPrimaryRed,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}