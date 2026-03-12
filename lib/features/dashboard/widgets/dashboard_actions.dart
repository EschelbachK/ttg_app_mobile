import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/dashboard_provider.dart';

class DashboardActions extends ConsumerWidget {
  const DashboardActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);

    return FloatingActionButton(
      backgroundColor: Colors.redAccent,
      onPressed: () async {
        final c = TextEditingController();
        final r = await showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
            content: TextField(controller: c),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Abbrechen")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, c.text),
                  child: const Text("Erstellen")),
            ],
          ),
        );
        if (r != null) notifier.addFolder(r);
      },
      child: const Icon(Icons.create_new_folder),
    );
  }
}