import 'package:flutter/material.dart';

class WorkoutHeader extends StatelessWidget {
  final double volume;

  const WorkoutHeader({super.key, required this.volume});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Volume: ${volume.toStringAsFixed(0)} kg',
              style: const TextStyle(fontSize: 18),
            ),
            const Icon(Icons.fitness_center),
          ],
        ),
      ),
    );
  }
}