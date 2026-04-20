import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
import 'settings_tile.dart';

class SoundModeTile extends ConsumerWidget {
  const SoundModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    return Column(
      children: [
        SettingsTile(
          icon: Icons.music_note,
          title: 'Audio & Töne',
          value: s.soundEnabled,
          onChanged: (_) => n.toggleSound(),
          expandable: true,
          isExpanded: s.soundExpanded,
          onTap: n.toggleSoundExpanded,
        ),

        if (s.soundExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wähle hier, welche akustischen Signale die App ausgeben soll.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                _row(
                  'Töne für Countdowns & Timer',
                  s.countdownSound,
                  s.soundEnabled ? n.toggleCountdownSound : null,
                ),
                _row(
                  'Startsound aktivieren',
                  s.startSound,
                  s.soundEnabled ? n.toggleStartSound : null,
                ),
                _row(
                  'Gesprochenes Feedback',
                  s.voiceFeedback,
                  s.soundEnabled ? n.toggleVoiceFeedback : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _row(String text, bool value, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onTap == null ? null : (_) => onTap(),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: onTap == null ? Colors.white38 : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}