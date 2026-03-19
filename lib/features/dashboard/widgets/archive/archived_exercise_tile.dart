import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ArchivedExerciseTile extends StatelessWidget {

  final Exercise exercise;

  const ArchivedExerciseTile({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        children: [

          const Icon(
            Icons.circle,
            size: 6,
            color: Colors.white38,
          ),

          const SizedBox(width: 8),

          Text(
            exercise.name,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}