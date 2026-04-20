import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
import '../widgets/settings_bottom_sheets.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/keyboard_mode_expand.dart';
import '../widgets/sound_mode_expand.dart';

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
              children: [
                SettingsTile(
                  icon: Icons.timer,
                  title: 'Satzpause',
                  subtitle: '${s.restTimerSeconds}s',
                  onTap: () => showRestTimerSheet(context, s, n),
                ),
                const KeyboardModeTile(),
                const SoundModeTile(),
              ],
            ),

            SettingsSection(
              title: 'ALLGEMEINE EINSTELLUNGEN',
              children: [
                const SettingsTile(
                  icon: Icons.language,
                  title: 'Sprache & Lokalisierung',
                ),
                SettingsTile(
                  icon: Icons.text_fields,
                  title: 'Schriftgröße',
                  subtitle: '${s.fontScale.toStringAsFixed(1)}x',
                  onTap: () => showFontScaleSheet(context, s, n),
                ),
                SettingsTile(
                  icon: Icons.lightbulb_outline,
                  title: 'Heller Modus',
                  value: s.lightMode,
                  onChanged: (_) => n.toggleLightMode(),
                ),
                SettingsTile(
                  icon: Icons.wifi_off,
                  title: 'Offline-Modus',
                  value: s.offlineMode,
                  onChanged: (_) => n.toggleOffline(),
                ),
                SettingsTile(
                  icon: Icons.cloud,
                  title: 'Synchronisation',
                  value: s.syncEnabled,
                  onChanged: (_) => n.toggleSync(),
                ),
              ],
            ),

            SettingsSection(
              title: 'DEIN ACCOUNT',
              children: [
                SettingsTile(
                  icon: Icons.lock,
                  title: 'Passwort',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Datenschutz',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.warning_amber,
                  title: 'Account löschen',
                  onTap: () => showDeleteAccountSheet(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}