import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../state/dashboard_provider.dart';

class DashboardActions extends ConsumerWidget {
  const DashboardActions({super.key});

  static Future<void> showCreateFolderDialog(
      BuildContext context, WidgetRef ref) async {

    final notifier = ref.read(dashboardProvider.notifier);
    final controller = TextEditingController();

    final result = await showDialog<String>(
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
            autofocus: true,
            cursorColor: AppTheme.primaryRed,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Name eingeben",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x44FF3B30),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFF3B30),
                  width: 2,
                ),
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Abbrechen",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text("Erstellen"),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      notifier.addFolder(result.trim());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),

        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryButtonGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.5),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),

          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Neuen Plan erstellen"),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 32,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),

            onPressed: () {
              DashboardActions.showCreateFolderDialog(context, ref);
            },
          ),
        ),
      ),
    );
  }
}