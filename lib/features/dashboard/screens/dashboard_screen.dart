import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../state/dashboard_provider.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/dashboard_toggle.dart';
import '../widgets/dashboard_actions.dart';
import '../widgets/folder_card.dart';
import '../widgets/archived_plan_tile.dart'; // 🔥 NEU
import '../widgets/archived_muscle_group_tile.dart'; // 🔥 NEU
import '../widgets/archived_folder_tile.dart'; // 🔥 NEU
import 'muscle_group_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Stack(
      children: [

        /// BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            "assets/images/dashboard_bg.png",
            fit: BoxFit.cover,
          ),
        ),

        /// DARK OVERLAY
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

              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          DashboardActions.showCreateFolderDialog(context, ref);
                        },
                      )
                    else
                      const SizedBox(width: 26),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// CONTAINER
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),

                      child: Container(
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),

                        child: state.showArchive

                        /// 🔥 ARCHIVE VIEW (REFACTORED)
                            ? ListView(
                          children: [

                            if (state.archivedFolders.isNotEmpty) ...[
                              _archiveSection("ARCHIVIERTE TRAININGSPLÄNE"),

                              /// 🔥 HIER ERSETZT DURCH NEUES TILE
                              ...state.archivedFolders.map((folder) {
                                return ArchivedFolderTile(folder: folder);
                              }),

                              const SizedBox(height: 20),
                            ],

                            if (state.archivedPlans.isNotEmpty) ...[
                              _archiveSection("ARCHIVIERTE MUSKELGRUPPEN"),

                              /// 🔥 HIER NEUE TILES
                              ...state.archivedPlans.map((plan) {
                                return ArchivedPlanTile(plan: plan);
                              }),
                            ],
                          ],
                        )

                        /// NORMAL VIEW
                            : state.folders.isEmpty
                            ? const DashboardActions()

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