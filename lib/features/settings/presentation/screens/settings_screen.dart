import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../core/auth/auth_actions.dart';
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

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final auth = ref.watch(authProvider);
    final sync = ref.watch(syncStateProvider);
    final t = Theme.of(context);

    String syncText;
    switch (sync) {
      case SyncStatus.syncing:
        syncText = "Synchronisiere...";
        break;
      case SyncStatus.success:
        syncText = "Synchronisiert";
        break;
      case SyncStatus.error:
        syncText = "Fehler";
        break;
      default:
        syncText = "Inaktiv";
    }

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

            /// USER INFO
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.username ?? "User",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.user?.email ?? "",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        AuthActions.logout(ref, context),
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),

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
                const LightModeExpand(),
                const OfflineModeExpand(),
                const SyncModeExpand(),

                /// SYNC STATUS VISUAL
                SettingsTile(
                  icon: Icons.sync,
                  title: 'Sync Status',
                  trailing: Text(
                    syncText,
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
              children: [
                AccountExpand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}