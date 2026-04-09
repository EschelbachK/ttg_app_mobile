import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import 'workout_active_screen.dart';

class WorkoutStartScreen extends ConsumerWidget {
  const WorkoutStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(workoutApiProvider).startWorkout();
            await ref.read(workoutProvider.notifier).loadActiveWorkout();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WorkoutActiveScreen(),
              ),
            );
          },
          child: const Text('Start Workout'),
        ),
      ),
    );
  }
}