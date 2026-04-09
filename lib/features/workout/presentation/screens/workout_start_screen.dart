import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../../providers/plan_provider.dart';

class WorkoutStartScreen extends ConsumerWidget {
  const WorkoutStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(planProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await ref.read(workoutProvider.notifier).startWorkout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/workout/active');
                }
              },
              child: const Text('Quick Start'),
            ),
            const SizedBox(height: 24),
            ...plans.map((p) => ListTile(
              title: Text(p.name),
              onTap: () async {
                await ref
                    .read(workoutProvider.notifier)
                    .startWorkoutFromPlan();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                      context, '/workout/active');
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}