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
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 8, 10),
            child: Text(
              'Aktiviere den Tastatur-Modus, um Gewicht und Wiederholungen direkt über die Tastatur einzugeben.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}