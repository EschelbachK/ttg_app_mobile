import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/settings_provider.dart';

Widget _glass(BuildContext c, Widget child) {
  final t = Theme.of(c);
  final dark = t.brightness == Brightness.dark;

  final box = Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: dark ? null : Colors.white,
      gradient: dark
          ? LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.02),
        ],
      )
          : null,
      border: Border.all(
        color: dark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.06),
      ),
      boxShadow: [
        BoxShadow(
          color: dark
              ? Colors.black.withOpacity(0.4)
              : Colors.black.withOpacity(0.08),
          blurRadius: 25,
          spreadRadius: -8,
        ),
      ],
    ),
    child: child,
  );

  return ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: dark
        ? BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
      child: box,
    )
        : box,
  );
}

Widget _btn(String text, VoidCallback tap, {Color? color}) {
  return GestureDetector(
    onTap: tap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            (color ?? AppTheme.primaryRed).withOpacity(0.9),
            color ?? AppTheme.primaryRed,
          ],
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

void showFontScaleSheet(BuildContext c, SettingsState s, SettingsNotifier n) {
  double temp = s.fontScale;

  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (_, set) {
        final t = Theme.of(c);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: _glass(
            c,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SCHRIFTGRÖSSE', style: t.textTheme.bodySmall),
                const SizedBox(height: 10),
                Text('${temp.toStringAsFixed(1)}x', style: t.textTheme.titleLarge),
                Slider(
                  value: temp,
                  min: 0.8,
                  max: 1.5,
                  activeColor: AppTheme.primaryRed,
                  onChanged: (v) => set(() => temp = v),
                ),
                const SizedBox(height: 10),
                _btn('Speichern', () {
                  n.setFontScale(temp);
                  Navigator.pop(c);
                }),
              ],
            ),
          ),
        );
      },
    ),
  );
}

void showPasswordSheet(BuildContext c) {
  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: _glass(
        c,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PASSWORT'),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(hintText: 'Neues Passwort')),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(hintText: 'Wiederholen')),
            const SizedBox(height: 16),
            _btn('Speichern', () => Navigator.pop(c)),
          ],
        ),
      ),
    ),
  );
}

void showPrivacySheet(BuildContext c) {
  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: _glass(
        c,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('DATENSCHUTZ'),
            const SizedBox(height: 10),
            _btn('Datenschutzerklärung lesen', () {}),
          ],
        ),
      ),
    ),
  );
}

void showDeleteAccountSheet(BuildContext c) {
  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: _glass(
        c,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ACCOUNT LÖSCHEN'),
            const SizedBox(height: 10),
            _btn('Account löschen', () => Navigator.pop(c), color: Colors.red),
          ],
        ),
      ),
    ),
  );
}