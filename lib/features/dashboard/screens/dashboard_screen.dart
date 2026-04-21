import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/settings/settings_state.dart';
import '../../workout/application/workout_history_store.dart';
import '../../workout/presentation/widgets/progress_chart.dart';
import '../state/dashboard_provider.dart';
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

  Widget _section(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final settings = ref.watch(settingsProvider);
    final history = ref.watch(workoutHistoryStoreProvider);

    final theme = Theme.of(context);
    final notifier = ref.read(dashboardProvider.notifier);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/dashboard_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.55)
                : Colors.white.withOpacity(0.6),
          ),
        ),
        Scaffold(
          key: scaffoldKey,
          drawer: const TtgDrawer(),
          backgroundColor: Colors.transparent,
          appBar: DashboardTopBar(
            selectedTab: selectedTab,
            onTabChanged: (i) => setState(() => selectedTab = i),
            onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (settings.offlineMode)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.4),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "OFFLINE MODUS AKTIV",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                if (selectedTab == 1)
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        if (history.isNotEmpty)
                          ProgressChart(history: history),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: _buildContent(context, state, settings),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, DashboardState state, SettingsState settings) {
    final theme = Theme.of(context);

    if (settings.offlineMode) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.white38),
            const SizedBox(height: 12),
            Text(
              "Offline Modus aktiv",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              "Keine Verbindung zum Server",
              style:
              theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
            ),
          ],
        ),
      );
    }

    if (state.showArchive) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          if (state.archivedPlans.isNotEmpty) ...[
            _section(context, "Archivierte Trainingspläne"),
            ...state.archivedPlans.map((p) => ArchivedPlanTile(plan: p)),
          ],
          if (state.archivedFolders.isNotEmpty) ...[
            _section(context, "Archivierte Muskelgruppen"),
            ...state.archivedFolders.map((f) => ArchivedFolderTile(folder: f)),
          ],
        ],
      );
    }

    if (state.isLoading)
      return const Center(child: CircularProgressIndicator());

    if (state.trainingPlans.isEmpty) {
      return Center(
        child: Text(
          "Keine Trainingspläne vorhanden",
          style: theme.textTheme.bodyMedium,
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
}