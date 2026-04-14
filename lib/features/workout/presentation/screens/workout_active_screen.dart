import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../../../core/ui/ttg_leave_workout_dialog.dart';
import '../../providers/workout_provider.dart';
import '../../providers/motivation_provider.dart';
import '../widgets/collapsible_exercise_block.dart';
import '../widgets/workout_start_overlay.dart';
import '../widgets/workout_finish_overlay.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutActiveScreen extends ConsumerStatefulWidget {
  const WorkoutActiveScreen({super.key});

  @override
  ConsumerState<WorkoutActiveScreen> createState() => _State();
}

class _State extends ConsumerState<WorkoutActiveScreen> {
  late bool _showStartOverlay;
  bool _showFinishOverlay = false;

  String? _activeRestMessage;

  @override
  void initState() {
    super.initState();
    final s = ref.read(workoutProvider);
    _showStartOverlay = s.session != null && !s.isPaused;
  }

  Future<void> _exit(BuildContext c) async {
    final ctrl = ref.read(workoutProvider.notifier);
    final r = await showTTGLeaveWorkoutDialog(context: c);
    if (r == null) return;

    if (r == "finish") {
      await ctrl.finishWorkout();
      if (!mounted) return;
      setState(() => _showFinishOverlay = true);
      return;
    }

    ctrl.pauseWorkout();
    if (!c.mounted) return;
    c.go('/workout/start');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutProvider);
    final ctrl = ref.read(workoutProvider.notifier);
    final s = state.session;

    if (state.triggerFinishFlow && !_showFinishOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _showFinishOverlay = true);
          ref.read(workoutProvider.notifier).state =
              state.copyWith(triggerFinishFlow: false);
        }
      });
    }

    if (s == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: TtgBackground(
          child: Center(
            child: Text('Kein Workout', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final completedMuscleNames = s.groups.where((g) {
      return g.exercises.every(
            (e) => e.sets.every((set) => set.completed == true),
      );
    }).map((g) => g.name).toList();

    final volume = s.groups
        .expand((g) => g.exercises)
        .fold<double>(
      0,
          (sum, e) =>
      sum + e.sets.fold<double>(0, (s, x) => s + x.weight * x.reps),
    );

    // ✅ FIX: immer aktuelle Message übernehmen
    if (state.restMessage != null) {
      _activeRestMessage = state.restMessage;
    }

    if (ctrl.restSeconds == 0) {
      _activeRestMessage = null;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          TtgBackground(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: SafeArea(
                    top: false,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        for (final g in s.groups) ...[
                          const SizedBox(height: 20),
                          _PremiumGroupHeader(
                            key: ValueKey('header_${g.name}'),
                            title: g.name,
                          ),
                          const SizedBox(height: 14),
                          ...g.exercises.map(
                                (e) => Padding(
                              key: ValueKey('padding_${e.id}'),
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CollapsibleExerciseBlock(
                                key: ValueKey('exercise_${e.id}'),
                                exercise: e,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: _TopBar(
                    onBack: () => _exit(context),
                  ),
                ),
              ],
            ),
          ),

          if (_showStartOverlay)
            WorkoutStartOverlay(
              onFinish: () => setState(() => _showStartOverlay = false),
            ),

          if (ctrl.restSeconds > 0)
            _RestOverlay(
              key: ValueKey(ctrl.restSeconds),
              seconds: ctrl.restSeconds,
              onSkip: ctrl.stopRestTimer,
              message: _activeRestMessage,
            ),

          if (_showFinishOverlay)
            WorkoutFinishOverlay(
              completedMuscles: completedMuscleNames,
              onDone: () {
                if (mounted) context.go('/workout/summary');
              },
            ),
        ],
      ),
    );
  }
}

class _RestOverlay extends StatelessWidget {
  final int seconds;
  final VoidCallback onSkip;
  final String? message;

  const _RestOverlay({
    super.key,
    required this.seconds,
    required this.onSkip,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (seconds / 60).clamp(0.0, 1.0);

    String done = "", next = "";

    if (message != null && message!.isNotEmpty) {
      final parts = message!.split("Nächste:");
      done = parts.first
          .replaceAll(RegExp(r'[🔥➡️➜➝]'), '')
          .replaceAll("abgeschlossen", "")
          .trim();

      if (parts.length > 1) {
        next = parts.last
            .replaceAll(RegExp(r'[➡️➜➝]'), '')
            .trim();
      }
    }

    Widget line(String t) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, kPrimaryRed],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          t.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 24,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryRed, Colors.transparent],
            ),
          ),
        ),
      ],
    );

    return Positioned.fill(
      child: GestureDetector(
        onTap: onSkip,
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        color: kPrimaryRed,
                        backgroundColor: Colors.white10,
                      ),
                    ),
                    Text(
                      '$seconds',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'TIPPEN ZUM ÜBERSPRINGEN',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    letterSpacing: 3,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                if (message != null && message!.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 28),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "ABGESCHLOSSEN",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            line(done),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Icon(Icons.keyboard_arrow_down, color: kPrimaryRed, size: 26),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 28),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(
                            color: kPrimaryRed.withOpacity(0.6),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "JETZT",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            line(next),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            ),
          ),

          const Spacer(),

          const Text(
            'WORKOUT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),

          const Spacer(),

          // Dummy spacer damit es wirklich zentriert bleibt
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _PremiumGroupHeader extends StatelessWidget {
  final String title;

  const _PremiumGroupHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, kPrimaryRed, Colors.transparent],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: kPrimaryRed,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, kPrimaryRed, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}