import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_folder.dart';
import '../state/dashboard_provider.dart';
import 'plan_tile.dart';

class FolderCard extends ConsumerWidget {
  final TrainingFolder folder;
  const FolderCard({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B1F23), Color(0xFF121416)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x33FF3B30)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              color: Color(0xFF20252A),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder, color: Color(0xFFFF3B30)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(folder.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  color: Colors.white54,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  color: Colors.white54,
                  onPressed: () => notifier.deleteFolder(folder.id),
                ),
              ],
            ),
          ),

          ...folder.plans.map(
                (p) => PlanTile(
              title: p.name,
              onDelete: () => notifier.deletePlan(folder.id, p.id),
            ),
          ),

          InkWell(
            onTap: () => _createPlanDialog(context, notifier),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text(
                "+ Muskelgruppe hinzufügen",
                style: TextStyle(
                  color: Color(0xFFFF3B30),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createPlanDialog(BuildContext context, DashboardNotifier notifier) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1F23),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Neue Muskelgruppe",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Name eingeben",
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
              child: const Text("Abbrechen"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                notifier.addPlan(folder.id, name);

                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
              child: const Text("Erstellen"),
            ),
          ],
        );
      },
    );
  }}