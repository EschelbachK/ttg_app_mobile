import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/volume_chart.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    final controller = ref.read(workoutProvider.notifier);
    final session = state.session;

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('No workout')),
      );
    }

    final volumes = session.exercises
        .map((e) => e.sets.fold(0.0, (s, set) => s + set.weight * set.reps))
        .toList();

    final totalVolume =
    volumes.fold(0.0, (sum, v) => sum + v);

    final suggestions = controller.buildNextSessionSuggestions();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Volume: ${totalVolume.toStringAsFixed(0)} kg'),
            const SizedBox(height: 20),
            VolumeChart(volumes: volumes),
            const SizedBox(height: 20),
            const Text('Next Session Vorschlag'),
            const SizedBox(height: 12),
            ...suggestions.map((s) {
              final color = s.reason.contains('increase')
                  ? Colors.green
                  : s.reason.contains('plateau')
                  ? Colors.orange
                  : Colors.white;

              return ListTile(
                title: Text(s.exerciseName),
                subtitle: Text('${s.weight} kg x ${s.reps}'),
                trailing: Text(
                  s.reason,
                  style: TextStyle(color: color),
                ),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await controller.startWorkoutFromPlan();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                      context, '/workout/active');
                }
              },
              child: const Text('Übernehmen & starten'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/dashboard'),
                );
              },
              child: const Text('Finish Workout'),
            ),
          ],
        ),
      ),
    );
  }
}