import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
import 'settings_tile.dart';

class LanguageUnitExpand extends ConsumerWidget {
  const LanguageUnitExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    Widget group(List<Widget> children) => Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ],
    );

    Widget btn(bool active, String text, VoidCallback onTap) =>
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: active
                  ? Colors.blueAccent
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(text),
          ),
        );

    return Column(
      children: [
        SettingsTile(
          icon: Icons.language,
          title: 'Sprache & Lokalisierung',
          value: true,
          expandable: true,
          isExpanded: s.languageExpanded,
          onTap: n.toggleLanguageExpanded,
        ),

        if (s.languageExpanded)
          Column(
            children: [
              group([
                btn(s.language == 'en', 'english',
                        () => n.setLanguage('en')),
                btn(s.language == 'de', 'deutsch',
                        () => n.setLanguage('de')),
              ]),
              group([
                btn(s.weightUnit == 'kg', 'KG',
                        () => n.setWeightUnit('kg')),
                btn(s.weightUnit == 'lbs', 'LBS',
                        () => n.setWeightUnit('lbs')),
              ]),
              group([
                btn(s.heightUnit == 'cm', 'CM',
                        () => n.setHeightUnit('cm')),
                btn(s.heightUnit == 'in', 'INCHES',
                        () => n.setHeightUnit('in')),
              ]),
            ],
          ),
      ],
    );
  }
}