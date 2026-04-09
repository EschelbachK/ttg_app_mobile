import 'package:flutter/material.dart';

class SetRow extends StatelessWidget {
  final int index;
  final double weight;
  final int reps;
  final bool completed;

  const SetRow({
    super.key,
    required this.index,
    required this.weight,
    required this.reps,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('#${index + 1}'),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
            Text('$weight kg'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
            Text('$reps reps'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
        Checkbox(
          value: completed,
          onChanged: (_) {},
        ),
      ],
    );
  }
}