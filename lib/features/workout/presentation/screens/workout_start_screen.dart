import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

class WorkoutStartScreen extends ConsumerWidget {
  const WorkoutStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(workoutProvider.notifier).startWorkout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/workout/active');
            }
          },
          child: const Text('Start Workout'),
        ),
      ),
    );
  }
}