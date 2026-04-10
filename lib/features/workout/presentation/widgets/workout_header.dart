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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WORKOUT',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  '${volume.toStringAsFixed(0)} KG',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(Icons.fitness_center, size: 28),
          ],
        ),
      ),
    );
  }
}