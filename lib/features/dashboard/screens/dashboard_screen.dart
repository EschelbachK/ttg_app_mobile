import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_input_dialog.dart';

import '../state/dashboard_provider.dart';
import '../widgets/dashboard/dashboard_top_bar.dart';

import '../widgets/archive/archived_plan_tile.dart';
import '../widgets/archive/archived_folder_tile.dart';

import 'training_plan_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String? expandedPlanId;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => ref.read(dashboardProvider.notifier).loadTrainingPlans(),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/dashboard_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.55)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: DashboardTopBar(
            selectedTab: selectedTab,
            onTabChanged: (i) => setState(() => selectedTab = i),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        state.showArchive
                            ? "ARCHIV"
                            : "MEINE TRAININGSPLÄNE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (!state.showArchive)
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: AppTheme.primaryRed,
                          ),
                          onPressed: () => showTTGInputDialog(
                            context: context,
                            title: "Neuer Trainingsplan",
                            buttonText: "Erstellen",
                            onSubmit: (v) async {
                              await ref
                                  .read(dashboardProvider.notifier)
                                  .createTrainingPlan(v);
                            },
                          ),
                        )
                      else
                        const SizedBox(width: 26),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: _buildContent(state),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(DashboardState state) {
    if (state.showArchive) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          if (state.archivedPlans.isNotEmpty) ...[
            _section("Archivierte Trainingspläne"),
            ...state.archivedPlans.map((p) => ArchivedPlanTile(plan: p)),
          ],
          if (state.archivedFolders.isNotEmpty) ...[
            _section("Archivierte Muskelgruppen"),
            ...state.archivedFolders.map((f) => ArchivedFolderTile(folder: f)),
          ],
        ],
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.trainingPlans.isEmpty) {
      return const Center(
        child: Text(
          "Keine Trainingspläne vorhanden",
          style: TextStyle(color: Colors.white),
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