import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/volume_chart.dart';

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

    final volumes = session.exercises.map((e) {
      return e.sets.fold(
        0.0,
            (sum, s) => sum + s.weight * s.reps,
      );
    }).toList();

    final totalVolume =
    volumes.fold(0.0, (sum, v) => sum + v);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Volume: ${totalVolume.toStringAsFixed(0)} kg'),
            const SizedBox(height: 20),
            VolumeChart(volumes: volumes),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/dashboard'),
                );
              },
              child: const Text('Finish Workout'),
            )
          ],
        ),
      ),
    );
  }
}