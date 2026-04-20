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
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 8, 10),
            child: Text(
              'Trainiere ohne Internet. Deine Daten werden lokal gespeichert und automatisch synchronisiert, sobald du wieder online bist.',
              style: TextStyle(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}