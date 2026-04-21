import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import 'settings_tile.dart';

class LanguageUnitExpand extends ConsumerWidget {
  const LanguageUnitExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    Widget chip(String text, bool active, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: active
                ? const Color(0xFFE10600).withOpacity(0.9)
                : Colors.white.withOpacity(0.06),
            border: Border.all(
              color: active
                  ? const Color(0xFFE10600).withOpacity(0.6)
                  : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    Widget section(String title, List<Widget> children) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, left: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 90,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(
              child: Row(
                children: children
                    .map((c) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: c,
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }

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
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                section("SPRACHE", [
                  chip("DEUTSCH", s.language == 'de', () => n.setLanguage('de')),
                  chip("ENGLISH", s.language == 'en', () => n.setLanguage('en')),
                ]),
                section("GEWICHT", [
                  chip("KG", s.weightUnit == 'kg', () => n.setWeightUnit('kg')),
                  chip("LBS", s.weightUnit == 'lbs', () => n.setWeightUnit('lbs')),
                ]),
                section("GRÖSSE", [
                  chip("CM", s.heightUnit == 'cm', () => n.setHeightUnit('cm')),
                  chip("INCHES", s.heightUnit == 'in', () => n.setHeightUnit('in')),
                ]),
              ],
            ),
          ),
      ],
    );
  }
}