import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/ttg_background.dart';

import '../../../ai_coach/widgets/ai_coach_message.dart';
import '../../application/summary_provider.dart';
import '../../../gamification/application/gamification_provider.dart';
import '../../../ai_coach/application/ai_coach_provider.dart';
import '../widgets/animated_stat_card.dart';
import '../widgets/xp_progress_bar.dart';
import '../widgets/performance_block.dart';

const kPrimaryRed = Color(0xFFE10600);

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  final _controller = ScrollController();
  bool _atBottom = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final max = _controller.position.maxScrollExtent;
      final current = _controller.position.pixels;

      final isBottom = current >= max - 20;

      if (isBottom != _atBottom) {
        setState(() {
          _atBottom = isBottom;
        });
      }
    });
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(summaryProvider);
    final game = ref.watch(gamificationProvider);
    final ai = ref.watch(aiCoachProvider);

    if (summary == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Keine Daten vorhanden',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final xp = game.totalXP();
    final level = game.level();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TtgBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: SingleChildScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'WORKOUT STATISTIK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      PerformanceBlock(
                        current: summary.totalVolume,
                        previous: summary.previousVolume,
                      ),

                      AnimatedStatCard(
                        title: 'GESAMTVOLUMEN',
                        value: summary.totalVolume,
                        suffix: ' kg',
                        delay: 0,
                      ),
                      AnimatedStatCard(
                        title: 'SÄTZE',
                        value: summary.totalSets.toDouble(),
                        delay: 100,
                      ),
                      AnimatedStatCard(
                        title: 'WIEDERHOLUNGEN',
                        value: summary.totalReps.toDouble(),
                        delay: 200,
                      ),
                      AnimatedStatCard(
                        title: 'ÜBUNGEN',
                        value: summary.exercises.toDouble(),
                        delay: 300,
                      ),

                      const SizedBox(height: 20),

                      XpProgressBar(
                        xp: xp,
                        level: level,
                      ),

                      const SizedBox(height: 10),

                      AICoachMessage(
                        message: ai.coachMessage(),
                        state: _mapState(ai),
                      ),

                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 90,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _atBottom
                        ? Padding(
                      key: const ValueKey('done'),
                      padding:
                      const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryRed,
                            boxShadow: [
                              BoxShadow(
                                color:
                                kPrimaryRed.withOpacity(0.6),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'FERTIG',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    )
                        : Padding(
                      key: const ValueKey('scroll'),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: _scrollDown,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryRed,
                            boxShadow: [
                              BoxShadow(
                                color:
                                kPrimaryRed.withOpacity(0.6),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

CoachState _mapState(ai) {
  final fatigue = ai.fatigueScore();
  final trend = ai.performanceTrend();

  if (fatigue > 80) return CoachState.negative;
  if (fatigue > 65) return CoachState.warning;
  if (trend > 5) return CoachState.positive;
  if (trend < -5) return CoachState.negative;

  return CoachState.neutral;
}