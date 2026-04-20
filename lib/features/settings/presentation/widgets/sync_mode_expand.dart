import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
import 'settings_tile.dart';

class SyncModeExpand extends ConsumerWidget {
  const SyncModeExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    return Column(
      children: [
        SettingsTile(
          icon: Icons.cloud,
          title: 'Synchronisation',
          value: s.syncEnabled,
          onChanged: (_) => n.toggleSync(),
          expandable: true,
          isExpanded: s.syncExpanded,
          onTap: n.toggleSyncExpanded,
        ),

        if (s.syncExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Synchronisiert deine Trainingsdaten zwischen Geräten und sichert deinen Fortschritt.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: s.syncEnabled,
                      onChanged: (_) => n.toggleSync(),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(child: Text('Synchronisation aktivieren')),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}