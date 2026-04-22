import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import '../../../../core/offline/sync_state_provider.dart';
import '../../../../core/offline/sync_state.dart';
import '../widgets/settings_bottom_sheets.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/keyboard_mode_expand.dart';
import '../widgets/sound_mode_expand.dart';
import '../widgets/language_unit_expand.dart';
import '../widgets/light_mode_expand.dart';
import '../widgets/offline_mode_expand.dart';
import '../widgets/sync_mode_expand.dart';
import '../widgets/account_expand.dart';
import '../widgets/user_card.dart';
import '../widgets/weight_step_expand.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _sync(SyncStatus s) => switch (s) {
    SyncStatus.syncing => "Synchronisiere...",
    SyncStatus.success => "Synchronisiert",
    SyncStatus.error => "Fehler",
    _ => "Inaktiv",
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final sync = ref.watch(syncStateProvider);
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const SizedBox(height: 8),
            Center(
              child: Text(
                'EINSTELLUNGEN',
                style: t.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const UserCard(),
            const SettingsSection(
              title: 'WÄHREND DES TRAININGS',
              children: [KeyboardModeTile(), SoundModeTile()],
            ),
            SettingsSection(
              title: 'ALLGEMEINE EINSTELLUNGEN',
              children: [
                const LanguageUnitExpand(),
                SettingsTile(
                  icon: Icons.text_fields,
                  title: 'Schriftgröße',
                  onTap: () => showFontScaleSheet(context, s, n),
                  trailing: Text(
                    '${s.fontScale.toStringAsFixed(1)}x',
                    style: TextStyle(
                      color: t.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const WeightStepExpand(),
                const LightModeExpand(),
                const OfflineModeExpand(),
                const SyncModeExpand(),
                SettingsTile(
                  icon: Icons.sync,
                  title: 'Sync Status',
                  trailing: Text(
                    _sync(sync),
                    style: TextStyle(
                      color: t.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SettingsSection(
              title: 'DEIN ACCOUNT',
              children: [AccountExpand()],
            ),
          ],
        ),
      ),
    );
  }
}