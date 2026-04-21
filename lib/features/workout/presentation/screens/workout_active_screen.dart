import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/settings/settings_controller.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../../../core/ui/ttg_leave_workout_dialog.dart';
import '../../../../core/haptics/haptic_provider.dart';
import '../../../../core/audio/sound_provider.dart';

import '../../providers/workout_provider.dart';
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
    final haptic = ref.read(hapticProvider);
    final sound = ref.read(soundProvider);
    final settings = ref.read(settingsProvider);

    final s = state.session;

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

    final completedMuscleNames = s.groups
        .where((g) => g.exercises.every((e) =>
        e.sets.every((set) => set.completed == true)))
        .map((g) => g.name)
        .toList();

    final maxRest = settings.restTimerSeconds;
    final progress = (ctrl.restSeconds / maxRest).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        TtgBackground(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final g in s.groups) ...[
                      const SizedBox(height: 20),
                      _PremiumGroupHeader(title: g.name),
                      const SizedBox(height: 14),
                      ...g.exercises.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CollapsibleExerciseBlock(exercise: e),
                      )),
                    ],
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: _TopBar(onBack: () => _exit(context)),
            ),
          ]),
        ),

        if (_showStartOverlay)
          WorkoutStartOverlay(
              onFinish: () => setState(() => _showStartOverlay = false)),

        if (ctrl.restSeconds > 0)
          _RestOverlay(
            seconds: ctrl.restSeconds,
            progress: progress,
            onSkip: ctrl.stopRestTimer,
            onTick: (s) {
              if (s <= 3 && s > 0) {
                sound.playBeep();
                haptic.medium();
              }
              if (s == 0) {
                sound.playFinish();
                haptic.heavy();
              }
            },
          ),

        if (_showFinishOverlay)
          WorkoutFinishOverlay(
            completedMuscles: completedMuscleNames,
            onDone: () => context.go('/workout/summary'),
          ),
      ]),
    );
  }
}

class _RestOverlay extends StatefulWidget {
  final int seconds;
  final double progress;
  final VoidCallback onSkip;
  final Function(int) onTick;

  const _RestOverlay({
    required this.seconds,
    required this.progress,
    required this.onSkip,
    required this.onTick,
  });

  @override
  State<_RestOverlay> createState() => _RestOverlayState();
}

class _RestOverlayState extends State<_RestOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _RestOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onTick(widget.seconds);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onSkip,
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Center(
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) {
                  final scale = 1 + (_pulse.value * 0.08);
                  return Transform.scale(
                    scale: scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: widget.progress,
                            strokeWidth: 10,
                            color: kPrimaryRed,
                            backgroundColor: Colors.white10,
                          ),
                        ),
                        Text(
                          '${widget.seconds}',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
              child:
              const Icon(Icons.arrow_back, color: Colors.white, size: 18),
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
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _PremiumGroupHeader extends StatelessWidget {
  final String title;

  const _PremiumGroupHeader({required this.title});

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