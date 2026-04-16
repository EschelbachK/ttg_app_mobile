import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/summary_provider.dart';
import '../../../gamification/application/gamification_provider.dart';
import '../../../ai_coach/application/ai_coach_provider.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summaryProvider);
    final game = ref.watch(gamificationProvider);
    final ai = ref.watch(aiCoachProvider);

    if (summary == null) {
      return const Scaffold(
        body: Center(child: Text('Keine Daten vorhanden')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Zusammenfassung'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatCard(
              title: 'Gesamtvolumen',
              value: summary.totalVolume.toStringAsFixed(0),
            ),
            _StatCard(
              title: 'Sätze',
              value: summary.totalSets.toString(),
            ),
            _StatCard(
              title: 'Wiederholungen',
              value: summary.totalReps.toString(),
            ),
            _StatCard(
              title: 'Übungen',
              value: summary.exercises.toString(),
            ),

            const SizedBox(height: 20),

            // 🎮 XP
            _StatCard(
              title: 'Erfahrung (XP)',
              value: game.totalXP().toString(),
            ),

            const SizedBox(height: 20),

            // 🧠 Coach Message
            Text(
              ai.coachMessage(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fertig'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}