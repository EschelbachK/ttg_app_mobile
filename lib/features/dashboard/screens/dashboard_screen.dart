import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/dashboard_provider.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/dashboard_toggle.dart';
import '../widgets/dashboard_actions.dart';
import '../widgets/folder_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _createFolderDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1F26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Neuer Trainingsplan",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            cursorColor: const Color(0xFFFF3B30),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Name eingeben",
              hintStyle: TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0x44FF3B30)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFF3B30), width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Abbrechen",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  notifier.addFolder(name);
                }
                Navigator.pop(context);
              },
              child: const Text("Erstellen"),
            ),
          ],
        );
      },
    );
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const DashboardTopBar(),

      body: Column(
        children: [

          const SizedBox(height: 10),

          const DashboardToggle(),

          const SizedBox(height: 20),

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
                      color: Color(0xFFFF3B30),
                      size: 26,
                    ),
                    onPressed: () => _createFolderDialog(context, ref),
                  )
                else
                  const SizedBox(width: 26),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// FIXED CONTENT CONTAINER
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B1F23),
                    Color(0xFF121416),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0x33FF3B30),
                ),
              ),

              child: state.showArchive

              /// ARCHIVE VIEW
                  ? ListView(
                children: [

                  /// ARCHIVED TRAINING PLANS
                  if (state.archivedFolders.isNotEmpty) ...[
                    _archiveSection("ARCHIVIERTE TRAININGSPLÄNE"),

                    ...state.archivedFolders.map((folder) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F26),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [

                            const Icon(
                              Icons.folder,
                              color: Color(0xFFFF3B30),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                folder.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],

                  /// ARCHIVED MUSCLE GROUPS
                  if (state.archivedPlans.isNotEmpty) ...[
                    _archiveSection("ARCHIVIERTE MUSKELGRUPPEN"),

                    ...state.archivedPlans.map((plan) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F26),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [

                            const Icon(
                              Icons.archive,
                              color: Color(0xFFFF3B30),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                plan.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}