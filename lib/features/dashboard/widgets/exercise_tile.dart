import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseTile extends StatelessWidget {

  final Exercise exercise;

  const ExerciseTile({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1B1F23),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Exercise Name
          Text(
            exercise.name,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// Sets List
          Column(

            children: List.generate(

              exercise.sets,

                  (index) {

                return Padding(

                  padding: const EdgeInsets.symmetric(vertical: 4),

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      /// Set Number
                      Text(
                        "Set ${index + 1}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      /// Weight
                      Text(
                        "${exercise.weight} kg",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      /// Reps
                      Text(
                        "${exercise.reps} Wdh",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}