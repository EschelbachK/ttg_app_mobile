import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/privacy_webview.dart';
import '../../../../core/settings/settings_controller.dart';
import '../../../../core/settings/settings_state.dart';

Widget _sheet(BuildContext c, Widget child) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: child,
        ),
      ),
    ),
  );
}

Widget _handle() => Center(
  child: Container(
    width: 40,
    height: 4,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

Widget _btn(String text, VoidCallback tap, {Color? color}) {
  final c = color ?? AppTheme.primaryRed;

  return GestureDetector(
    onTap: tap,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: [c.withOpacity(0.9), c]),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}

Widget _input(String hint) {
  return TextField(
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}

void showFontScaleSheet(BuildContext c, SettingsState s, SettingsController n) {
  double temp = s.fontScale;

  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    builder: (_) => _sheet(
      c,
      StatefulBuilder(
        builder: (_, set) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),
            const Text('Schriftgröße',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text('${temp.toStringAsFixed(1)}x'),
            Slider(
              value: temp,
              min: 0.8,
              max: 1.5,
              activeColor: AppTheme.primaryRed,
              onChanged: (v) => set(() => temp = v),
            ),
            const SizedBox(height: 20),
            _btn('Speichern', () {
              n.setFontScale(temp);
              Navigator.pop(c);
            }),
          ],
        ),
      ),
    ),
  );
}

void showPasswordSheet(BuildContext c) {
  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _sheet(
      c,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const Text('Passwort ändern',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          _input('Neues Passwort'),
          const SizedBox(height: 14),
          _input('Neues Passwort wiederholen'),
          const SizedBox(height: 22),
          _btn('Speichern', () => Navigator.pop(c)),
        ],
      ),
    ),
  );
}

void showPrivacySheet(BuildContext c) {
  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    builder: (_) => _sheet(
      c,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const Text('Datenschutz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(
            'Wir nehmen den Schutz deiner Daten sehr ernst.\nMehr Infos findest du in der Datenschutzerklärung.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(height: 20),
          _btn('Datenschutzerklärung lesen', () {
            Navigator.pop(c);
            Navigator.push(
              c,
              MaterialPageRoute(builder: (_) => const PrivacyWebView()),
            );
          }),
        ],
      ),
    ),
  );
}

void showDeleteAccountSheet(BuildContext c) {
  showModalBottomSheet(
    context: c,
    backgroundColor: Colors.transparent,
    builder: (_) => _sheet(
      c,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const Text('Account löschen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(
            'Dieser Vorgang ist endgültig und kann nicht rückgängig gemacht werden.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(height: 20),
          _btn('Account löschen', () => Navigator.pop(c), color: Colors.red),
        ],
      ),
    ),
  );
}