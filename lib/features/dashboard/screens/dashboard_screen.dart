import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../state/dashboard_provider.dart';
import '../state/active_plan_provider.dart';
import '../widgets/dashboard/dashboard_toggle.dart';
import '../widgets/dashboard/dashboard_top_bar.dart';
import '../widgets/dashboard/dashboard_actions.dart';
import '../widgets/folder_card.dart';
import '../widgets/archive/archived_plan_tile.dart';
import '../widgets/archive/archived_folder_tile.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final notifier = ref.read(dashboardProvider.notifier);
      final planId = ref.read(activePlanIdProvider);

      if (planId != null && planId.isNotEmpty) {
        await notifier.loadFolders(planId);
        return;
      }

      try {
        final response = await notifier.api.dio.get('/training-plans');
        final data = response.data;

        if (data is List && data.isNotEmpty) {
          final firstPlanId = data.first['id']?.toString();

          if (firstPlanId != null && firstPlanId.isNotEmpty) {
            ref.read(activePlanIdProvider.notifier).state = firstPlanId;
            await notifier.loadFolders(firstPlanId);
          }
        }
      } catch (_) {}
    });
  }

  Widget _archiveSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final planId = ref.watch(activePlanIdProvider);

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
            color: Colors.black.withOpacity(0.55),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const DashboardTopBar(),
          body: Column(
            children: [
              const SizedBox(height: 10),
              const DashboardToggle(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      state.showArchive ? "ARCHIV" : "MEINE TRAININGSPLÄNE",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    if (!state.showArchive)
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: AppTheme.primaryRed,
                          size: 26,
                        ),
                        onPressed: () {
                          DashboardActions.showCreatePlanDialog(
                            context,
                            ref,
                          );
                        },
                      )
                    else
                      const SizedBox(width: 26),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: state.showArchive
                            ? ListView(
                          children: [
                            if (state.archivedFolders.isNotEmpty) ...[
                              _archiveSection("ARCHIVIERTE TRAININGSPLÄNE"),
                              ...state.archivedFolders.map((folder) {
                                return ArchivedFolderTile(folder: folder);
                              }),
                              const SizedBox(height: 20),
                            ],
                            if (state.archivedPlans.isNotEmpty) ...[
                              _archiveSection("ARCHIVIERTE MUSKELGRUPPEN"),
                              ...state.archivedPlans.map((plan) {
                                return ArchivedPlanTile(plan: plan);
                              }),
                            ],
                          ],
                        )
                            : state.isLoading
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : state.error != null
                            ? Center(
                          child: Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                            : state.folders.isEmpty
                            ? const Center(
                          child: DashboardActions(),
                        )
                            : ListView.builder(
                          itemCount: state.folders.length,
                          itemBuilder: (context, index) {
                            final folder = state.folders[index];
                            return FolderCard(folder: folder);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }
}