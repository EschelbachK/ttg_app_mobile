import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
import 'settings_tile.dart';

class KeyboardModeTile extends ConsumerWidget {
  const KeyboardModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    return Column(
      children: [
        SettingsTile(
          icon: Icons.keyboard,
          title: 'Tastatur-Modus',
          value: s.keyboardMode,
          onChanged: (_) => n.toggleKeyboard(),
          expandable: true,
          onTap: n.toggleKeyboardExpanded,
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: s.keyboardExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Column(
              children: [
                const Text(
                  'Aktiviere den Tastatur-Modus, wenn du bei der Eingabe von Gewicht und Wiederholungen die Tastatur nutzen möchtest.',
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: s.keyboardMode,
                      onChanged: (_) => n.toggleKeyboard(),
                    ),
                    const Text('Tastatur-Modus aktivieren'),
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