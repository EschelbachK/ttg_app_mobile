import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_controller.dart';
import '../../../core/settings/settings_state.dart';
import '../../../core/ui/ttg_input_dialog.dart';

import '../../workout/application/workout_history_store.dart';
import '../../workout/presentation/widgets/progress_chart.dart';
import '../../workout/presentation/widgets/volume_chart.dart';

import '../domain/dashboard_data.dart';
import '../state/dashboard_provider.dart';
import '../widgets/analytics/kpi_cards.dart';
import '../widgets/analytics/session_compare_card.dart';
import '../widgets/dashboard/dashboard_top_bar.dart';
import '../widgets/archive/archived_plan_tile.dart';
import '../widgets/archive/archived_folder_tile.dart';

import 'training_plan_card.dart';
import '../../navigation/presentation/widgets/ttg_drawer.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String? expandedPlanId;
  int selectedTab = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => ref.read(dashboardProvider.notifier).loadTrainingPlans(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final settings = ref.watch(settingsProvider);
    final entries = ref.watch(workoutHistoryStoreProvider);
    final t = Theme.of(context);

    final map = <String, double>{};
    for (final e in entries) {
      map[e.sessionId] = (map[e.sessionId] ?? 0) + (e.weight * e.reps);
    }

    final total = map.values.fold(0.0, (a, b) => a + b);
    final sessions = map.length;
    final avg = sessions == 0 ? 0.0 : total / sessions;
    final best = map.isEmpty ? 0.0 : map.values.reduce((a, b) => a > b ? a : b);
    final list = map.values.toList();

    final kpis = KPIs(
      totalVolume: total,
      avgVolume: avg,
      bestSession: best,
      totalSessions: sessions,
    );

    final compare = list.length < 2 ? (0.0, 0.0) : (list.last, list[list.length - 2]);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("assets/images/dashboard_bg.png", fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(.6)),
        ),
        Scaffold(
          key: scaffoldKey,
          drawer: const TtgDrawer(),
          backgroundColor: Colors.transparent,

          // ✅ FIX: kein Builder mehr
          appBar: DashboardTopBar(
            selectedTab: selectedTab,
            onTabChanged: (i) {
              setState(() => selectedTab = i);
              final n = ref.read(dashboardProvider.notifier);
              i == 1 ? n.showArchive() : n.showPlans();
            },
            onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
          ),

          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      _tab("PLÄNE", 0),
                      _tab("ARCHIV", 1),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MEINE TRAININGSPLÄNE",
                        style: t.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFFFF3B30)),
                        onPressed: settings.offlineMode
                            ? null
                            : () => showTTGInputDialog(
                          context: context,
                          title: "Neuer Trainingsplan",
                          buttonText: "Erstellen",
                          onSubmit: (v) async {
                            await ref.read(dashboardProvider.notifier).createTrainingPlan(v);
                          },
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: selectedTab == 1
                      ? _buildArchive(state)
                      : _buildPlans(state, settings),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlans(DashboardState state, SettingsState settings) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.trainingPlans.isEmpty) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF3B30).withOpacity(.6),
                blurRadius: 20,
                spreadRadius: 1,
              )
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: settings.offlineMode
                ? null
                : () => showTTGInputDialog(
              context: context,
              title: "Neuer Trainingsplan",
              buttonText: "Erstellen",
              onSubmit: (v) async {
                await ref.read(dashboardProvider.notifier).createTrainingPlan(v);
              },
            ),
            child: const Text(
              "+ Neuen Plan erstellen",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: state.trainingPlans.map((p) {
        return Column(
          children: [
            TrainingPlanCard(
              plan: p,
              expandedPlanId: expandedPlanId,
              onExpand: (id) => setState(() => expandedPlanId = id),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildArchive(DashboardState state) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (state.archivedPlans.isNotEmpty)
          ...state.archivedPlans.map((p) => ArchivedPlanTile(plan: p)),
        if (state.archivedFolders.isNotEmpty)
          ...state.archivedFolders.map((f) => ArchivedFolderTile(folder: f)),
      ],
    );
  }

  Widget _tab(String text, int index) {
    final selected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTab = index);
          final n = ref.read(dashboardProvider.notifier);
          index == 1 ? n.showArchive() : n.showPlans();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFF3B30) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}