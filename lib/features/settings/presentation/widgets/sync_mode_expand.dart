import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import 'settings_tile.dart';

class SyncModeExpand extends ConsumerWidget {
  const SyncModeExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final t = Theme.of(context);

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
            padding: const EdgeInsets.fromLTRB(16, 6, 8, 10),
            child: Text(
              'Synchronisiert deine Trainingsdaten automatisch und sichert deinen Fortschritt über alle Geräte hinweg.',
              style: t.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}