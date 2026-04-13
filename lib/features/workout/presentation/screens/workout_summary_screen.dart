import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../providers/workout_provider.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutProvider).session;

    if (session == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: TtgBackground(
          child: Center(
            child: Text('Keine Daten', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final exercises = session.groups.expand((g) => g.exercises);
    final volume = exercises.fold(
      0.0,
          (sum, e) =>
      sum + e.sets.fold(0.0, (s, set) => s + set.weight * set.reps),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TtgBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'WORKOUT COMPLETE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _Card('VOLUME', '${volume.toStringAsFixed(0)} KG'),
                    const SizedBox(height: 12),
                    _Card('EXERCISES', '${exercises.length}'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _Button(
                  text: 'ZURÜCK',
                  onTap: () => context.go('/workout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String value;

  const _Card(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _Button({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryRed,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}