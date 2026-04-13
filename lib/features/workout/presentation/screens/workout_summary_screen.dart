import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../providers/workout_provider.dart';
import '../../providers/motivation_provider.dart';
import '../../application/workout_summary_mapper.dart';
import '../../application/analytics_engine.dart';
import '../widgets/progress_chart.dart';
import '../widgets/streak_widget.dart';
import 'package:go_router/go_router.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutSummaryScreen extends ConsumerStatefulWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  ConsumerState<WorkoutSummaryScreen> createState() =>
      _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState
    extends ConsumerState<WorkoutSummaryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fade;
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();

    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fade.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(workoutProvider);
    final motivation = ref.watch(motivationProvider);

    final session = workout.session;
    if (session == null) return const SizedBox();

    final history = WorkoutSummaryMapper.toHistory(session);
    final analytics = AnalyticsEngine();

    final volume = analytics.totalVolume(history);
    final avgWeight = analytics.averageWeight(history);
    final reps = analytics.totalReps(history);
    final improving = analytics.isImproving(history);

    final message = motivation.state.last?.message;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TtgBackground(
        child: FadeTransition(
          opacity: _fade,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Text(
                  'WORKOUT ÜBERSICHT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                if (message != null)
                  ScaleTransition(
                    scale: Tween(begin: 0.9, end: 1.0)
                        .animate(CurvedAnimation(
                      parent: _fade,
                      curve: Curves.easeOut,
                    )),
                    child: _MotivationCard(message: message),
                  ),

                const SizedBox(height: 14),
                StreakWidget(motivator: motivation.engine),
                const SizedBox(height: 28),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _kpiRow(volume, avgWeight, reps, improving),

                      const SizedBox(height: 32),

                      const Center(
                        child: Text(
                          'FORTSCHRITT',
                          style: TextStyle(
                            color: Colors.white54,
                            letterSpacing: 2,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      AnimatedBuilder(
                        animation: _glow,
                        builder: (_, __) {
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryRed.withOpacity(
                                      0.15 + _glow.value * 0.2),
                                  blurRadius: 40,
                                )
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: SizedBox(
                              height: 300,
                              child: ProgressChart(history: history),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AnimatedBuilder(
                    animation: _glow,
                    builder: (_, __) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF1A1A), Color(0xFFB30000)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryRed.withOpacity(
                                  0.4 + _glow.value * 0.4),
                              blurRadius: 30,
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => context.go('/workout'),
                            child: const Center(
                              child: Text(
                                'Schließen',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kpiRow(double volume, double avg, int reps, bool improving) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _card('Volumen', '$volume KG', true)),
            const SizedBox(width: 12),
            Expanded(child: _card('Ø Gewicht', avg.toString())),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _card('Wiederholungen', reps.toString())),
            const SizedBox(width: 12),
            Expanded(child: _trendCard(improving)),
          ],
        ),
      ],
    );
  }

  Widget _card(String title, String value, [bool highlight = false]) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: highlight ? kPrimaryRed : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendCard(bool improving) {
    final color = improving ? Colors.green : Colors.red;
    final icon = improving ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Trend', style: TextStyle(color: Colors.white54)),
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                improving ? 'STEIGEND' : 'FALLEND',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  final String message;
  const _MotivationCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}