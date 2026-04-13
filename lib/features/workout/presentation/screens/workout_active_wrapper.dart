import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../providers/workout_provider.dart';
import '../widgets/collapsible_exercise_block.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutActiveScreen extends ConsumerWidget {
  final VoidCallback onExit;

  const WorkoutActiveScreen({super.key, required this.onExit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    final controller = ref.read(workoutProvider.notifier);
    final session = state.session;

    if (session == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: TtgBackground(
          child: Center(
            child: Text('Kein Workout', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final totalVolume = session.groups
        .expand((g) => g.exercises)
        .fold<double>(
      0,
          (sum, e) =>
      sum + e.sets.fold<double>(0, (s, set) => s + set.weight * set.reps),
    );

    return WillPopScope(
      onWillPop: () async {
        onExit();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            TtgBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    _TopBar(
                      volume: totalVolume,
                      onBack: onExit,
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          for (final group in session.groups) ...[
                            const SizedBox(height: 20),
                            _PremiumGroupHeader(title: group.name),
                            const SizedBox(height: 14),
                            ...group.exercises.map(
                                  (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CollapsibleExerciseBlock(exercise: e),
                              ),
                            ),
                          ],
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.showRest)
              _RestOverlay(
                seconds: controller.restSeconds,
                onSkip: controller.stopRestTimer,
              ),
          ],
        ),
        floatingActionButton: controller.showRest
            ? null
            : FloatingActionButton(
          backgroundColor: kPrimaryRed,
          onPressed: onExit,
          child: const Icon(Icons.close, color: Colors.white),
        ),
      ),
    );
  }
}

class _RestOverlay extends StatefulWidget {
  final int seconds;
  final VoidCallback onSkip;

  const _RestOverlay({required this.seconds, required this.onSkip});

  @override
  State<_RestOverlay> createState() => _RestOverlayState();
}

class _RestOverlayState extends State<_RestOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(vsync: this, duration: const Duration(seconds: 60))
    ..forward();

  late final Animation<double> _progress =
  Tween(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.linear),
  );

  @override
  void didUpdateWidget(covariant _RestOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.value = 1 - (widget.seconds / 60);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onSkip,
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(220, 220),
                            painter: _SmoothRingPainter(progress: _progress.value),
                          ),
                          Text(
                            '${widget.seconds}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'PAUSE',
                      style: TextStyle(color: Colors.white70, letterSpacing: 4),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tippen zum Überspringen',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SmoothRingPainter extends CustomPainter {
  final double progress;
  const _SmoothRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final bg = Paint()
      ..color = Colors.white12
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final fg = Paint()
      ..color = kPrimaryRed
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926535 / 2,
      2 * 3.1415926535 * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _SmoothRingPainter old) =>
      old.progress != progress;
}

class _TopBar extends StatelessWidget {
  final double volume;
  final VoidCallback onBack;

  const _TopBar({required this.volume, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Text(
                'WORKOUT',
                style: TextStyle(color: Colors.white38, fontSize: 15, letterSpacing: 2),
              ),
              const SizedBox(width: 8),
              Text(
                '${volume.toStringAsFixed(0)} KG',
                style: const TextStyle(
                  color: kPrimaryRed,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryRed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.fitness_center, color: Colors.white, size: 18),
          ),
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
    final divider = Colors.white.withOpacity(0.08);

    return Column(
      children: [
        Container(height: 1, color: divider),
        const SizedBox(height: 12),
        SizedBox(
          height: 18,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: kPrimaryRed,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: divider),
      ],
    );
  }
}