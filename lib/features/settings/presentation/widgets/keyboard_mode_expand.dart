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
          isExpanded: s.keyboardExpanded,
          onTap: n.toggleKeyboardExpanded,
        ),

        if (s.keyboardExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktiviere den Tastatur-Modus, wenn du bei der Eingabe von Gewicht und Wiederholungen die Tastatur nutzen möchtest.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(
                      value: s.keyboardMode,
                      onChanged: (_) => n.toggleKeyboard(),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Tastatur-Modus aktivieren',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}