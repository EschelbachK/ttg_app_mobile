import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings_provider.dart';
import '../widgets/settings_bottom_sheets.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/account_sheets.dart';

import '../widgets/keyboard_mode_expand.dart';
import '../widgets/sound_mode_expand.dart';
import '../widgets/language_unit_expand.dart';
import '../widgets/light_mode_expand.dart';
import '../widgets/offline_mode_expand.dart';
import '../widgets/sync_mode_expand.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: t.colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const SizedBox(height: 12),

            Center(
              child: Text(
                'EINSTELLUNGEN',
                style: t.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SettingsSection(
              title: 'WÄHREND DES TRAININGS',
              children: const [
                KeyboardModeTile(),
                SoundModeTile(),
              ],
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

                const LightModeExpand(),
                const OfflineModeExpand(),
                const SyncModeExpand(),
              ],
            ),

            SettingsSection(
              title: 'DEIN ACCOUNT',
              children: [
                SettingsTile(
                  icon: Icons.lock,
                  title: 'Passwort',
                  onTap: () => showPasswordSheet(context),
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Datenschutz',
                  onTap: () => showPrivacySheet(context),
                ),
                SettingsTile(
                  icon: Icons.warning_amber,
                  title: 'Account löschen',
                  onTap: () => showDeleteAccountSheetNew(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}