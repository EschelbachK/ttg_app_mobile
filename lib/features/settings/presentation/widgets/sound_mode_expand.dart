import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
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
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Steuere, welche akustischen Signale während deines Trainings abgespielt werden.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                _toggle(
                  context,
                  'Countdown & Timer',
                  s.countdownSound,
                  s.soundEnabled ? n.toggleCountdownSound : null,
                ),
                _toggle(
                  context,
                  'Startsound',
                  s.startSound,
                  s.soundEnabled ? n.toggleStartSound : null,
                ),
                _toggle(
                  context,
                  'Voice Feedback',
                  s.voiceFeedback,
                  s.soundEnabled ? n.toggleVoiceFeedback : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _toggle(
      BuildContext context,
      String text,
      bool value,
      VoidCallback? onTap,
      ) {
    final t = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 24,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: value
                    ? t.colorScheme.primary
                    : Colors.white.withOpacity(0.15),
              ),
              child: Align(
                alignment:
                value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
      ),
    );
  }
}