import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/volume_chart.dart';
import '../widgets/ttg_glass_card.dart';
import '../widgets/ttg_primary_button.dart';

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

    final totalVolume = volumes.fold(0.0, (sum, v) => sum + v);
    final suggestions = controller.buildNextSessionSuggestions();
    final suggestedPlan = controller.buildPlanFromSuggestions();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'WORKOUT SUMMARY',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TtgGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Volume: ${totalVolume.toStringAsFixed(0)} kg'),
                    const SizedBox(height: 12),
                    VolumeChart(volumes: volumes),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TtgGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NEXT SESSION'),
                    const SizedBox(height: 8),
                    ...suggestions.map((s) {
                      final color = s.reason.contains('increase')
                          ? Colors.green
                          : s.reason.contains('plateau')
                          ? Colors.orange
                          : Colors.white;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(s.exerciseName),
                            Text('${s.weight}kg x ${s.reps}'),
                            Text(s.reason, style: TextStyle(color: color)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              TtgPrimaryButton(
                text: 'Start Next Session',
                onTap: () async {
                  await controller.startWorkoutFromPlan(suggestedPlan);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                        context, '/workout/active');
                  }
                },
              ),
              const SizedBox(height: 12),
              TtgPrimaryButton(
                text: 'Finish',
                onTap: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/dashboard'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}