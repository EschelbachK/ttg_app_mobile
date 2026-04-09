import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    final session = state.session;

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('No workout')),
      );
    }

    final totalSets = session.exercises.fold(
      0,
          (sum, e) => sum + e.sets.length,
    );

    final totalVolume = session.exercises.fold(
      0.0,
          (sum, e) =>
      sum +
          e.sets.fold(
              0.0, (s, set) => s + set.weight * set.reps),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Sets: $totalSets'),
            Text('Volume: ${totalVolume.toStringAsFixed(0)} kg'),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
              },
              child: const Text('Finish Workout'),
            )
          ],
        ),
      ),
    );
  }
}