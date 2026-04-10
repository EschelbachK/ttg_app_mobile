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
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Kein Workout vorhanden',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final exercises = session.groups.expand((g) => g.exercises).toList();

    final volumes = exercises
        .map((e) =>
        e.sets.fold(0.0, (s, set) => s + set.weight * set.reps))
        .toList();

    final totalVolume =
    volumes.fold(0.0, (sum, v) => sum + v);

    final suggestions = controller.buildNextSessionSuggestions();
    final suggestedPlan =
    controller.buildPlanFromSuggestions();

    Color _color(String reason) {
      if (reason.contains('Reduce')) return Colors.red;
      if (reason.contains('Increase')) return Colors.green;
      if (reason.contains('plateau')) return Colors.orange;
      return Colors.white70;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'WORKOUT SUMMARY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              TtgGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volumen: ${totalVolume.toStringAsFixed(0)} kg',
                      style: const TextStyle(color: Colors.white),
                    ),
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
                    const Text(
                      'NÄCHSTE SESSION',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    ...suggestions.map((s) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                s.exerciseName,
                                style: const TextStyle(
                                    color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${s.weight}kg × ${s.reps}',
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                            Text(
                              s.reason,
                              style: TextStyle(color: _color(s.reason)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const Spacer(),

              TtgPrimaryButton(
                text: 'Next Session starten',
                onTap: () async {
                  await controller.startWorkoutFromPlan(
                      suggestedPlan);

                  if (!context.mounted) return;

                  Navigator.pushReplacementNamed(
                      context, '/workout/active');
                },
              ),

              const SizedBox(height: 12),

              TtgPrimaryButton(
                text: 'Beenden',
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