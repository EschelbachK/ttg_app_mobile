import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/dashboard_provider.dart';

class DashboardBottomBar extends ConsumerWidget {
  const DashboardBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),

        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),

            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          child: Row(
            children: [

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _createFolderDialog(context, notifier),
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text("ORDNER"),
                  style: _style(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("PLAN"),
                  style: _style(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _style() => ElevatedButton.styleFrom(
    backgroundColor: Colors.white.withOpacity(0.08),
    foregroundColor: const Color(0xFFFF3B30),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );

  void _createFolderDialog(BuildContext context, DashboardNotifier notifier) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1F23),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Neuer Plan",
            style: TextStyle(color: Colors.white),
          ),

          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),

            decoration: const InputDecoration(
              hintText: "Ordnername eingeben",
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

                notifier.addFolder(name);

                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
              child: const Text("Erstellen"),
            ),
          ],
        );
      },
    );
  }
}