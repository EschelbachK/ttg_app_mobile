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
          onTap: n.toggleSoundExpanded,
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: s.soundExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Column(
              children: [
                const Text(
                  'Wähle hier, welche akustischen Signale die App ausgeben soll.',
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Checkbox(
                      value: s.countdownSound,
                      onChanged: s.soundEnabled
                          ? (_) => n.toggleCountdownSound()
                          : null,
                    ),
                    const Text('Töne für Countdowns & Timer'),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: s.startSound,
                      onChanged: s.soundEnabled
                          ? (_) => n.toggleStartSound()
                          : null,
                    ),
                    const Text('Startsound aktivieren'),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: s.voiceFeedback,
                      onChanged: s.soundEnabled
                          ? (_) => n.toggleVoiceFeedback()
                          : null,
                    ),
                    const Text('Gesprochenes Feedback'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}