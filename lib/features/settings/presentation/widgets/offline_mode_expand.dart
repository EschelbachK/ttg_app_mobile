import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
import 'settings_tile.dart';

class OfflineModeExpand extends ConsumerWidget {
  const OfflineModeExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    return Column(
      children: [
        SettingsTile(
          icon: Icons.wifi_off,
          title: 'Offline-Modus',
          value: s.offlineMode,
          onChanged: (_) => n.toggleOffline(),
          expandable: true,
          isExpanded: s.offlineExpanded,
          onTap: n.toggleOfflineExpanded,
        ),

        if (s.offlineExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trainiere ohne Internetverbindung. Deine Daten werden lokal gespeichert und später synchronisiert.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: s.offlineMode,
                      onChanged: (_) => n.toggleOffline(),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(child: Text('Offline-Modus aktivieren')),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}