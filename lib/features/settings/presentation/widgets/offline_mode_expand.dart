import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import 'settings_tile.dart';

class OfflineModeExpand extends ConsumerWidget {
  const OfflineModeExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final t = Theme.of(context);

    final warning = s.syncEnabled && s.offlineMode;

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
            padding: const EdgeInsets.fromLTRB(16, 6, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trainiere ohne Internet. Deine Daten werden lokal gespeichert und automatisch synchronisiert, sobald du wieder online bist.',
                  style: t.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                if (warning) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Sync ist aktiv → wird im Offline-Modus pausiert',
                    style: t.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]
              ],
            ),
          ),
      ],
    );
  }
}