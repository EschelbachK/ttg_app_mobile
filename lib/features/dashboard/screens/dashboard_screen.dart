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

    Future.microtask(() {
      final planId = ref.read(activePlanIdProvider);
      if (planId != null) {
        ref.read(dashboardProvider.notifier).loadFolders(planId);
      }
    });
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
          child: Container(color: Colors.black.withOpacity(0.55)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const DashboardTopBar(),
          body: Column(
            children: [
              const SizedBox(height: 10),
              const DashboardToggle(),
              const SizedBox(height: 10),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                    ? Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                    : ListView.builder(
                  itemCount: state.folders.length,
                  itemBuilder: (context, index) {
                    final folder = state.folders[index];
                    return FolderCard(folder: folder);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}