import 'package:flutter/material.dart';
import '../state/dashboard_provider.dart';

class DashboardDialogs {
  static void createFolder(
      BuildContext context,
      DashboardNotifier notifier,
      String planId,
      ) {
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
            "Neuer Ordner",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Name des Ordners eingeben",
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

                notifier.addFolder(planId, name);

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