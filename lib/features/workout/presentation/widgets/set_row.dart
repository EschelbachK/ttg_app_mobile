import 'package:flutter/material.dart';

class SetRow extends StatelessWidget {
  final int index;
  final double weight;
  final int reps;

  const SetRow({
    super.key,
    required this.index,
    required this.weight,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('#${index + 1}'),
        Text('$weight kg'),
        Text('$reps reps'),
      ],
    );
  }
}