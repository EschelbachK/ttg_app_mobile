import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_sheet.dart';

Widget _field(BuildContext context, String hint, TextEditingController c) {
  final dark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: dark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.05),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: TextField(
      controller: c,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
      ),
    ),
  );
}

Widget _btn(String text, VoidCallback onTap, {Color? c, Gradient? g}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: g == null ? c : null,
        gradient: g,
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}

void showPasswordSheet(BuildContext context) {
  final p1 = TextEditingController();
  final p2 = TextEditingController();
  final t = Theme.of(context);

  showTTGBottomSheet(
    context: context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Passwort ändern', style: t.textTheme.titleMedium),
        const SizedBox(height: 12),
        _field(context, 'Neues Passwort', p1),
        _field(context, 'Neues Passwort wiederholen', p2),
        const SizedBox(height: 10),
        _btn('Speichern', () => Navigator.pop(context),
            g: AppTheme.primaryButtonGradient),
      ],
    ),
  );
}

void showPrivacySheet(BuildContext context) {
  final t = Theme.of(context);

  showTTGBottomSheet(
    context: context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Datenschutz', style: t.textTheme.titleMedium),
        const SizedBox(height: 10),
        const Text(
          'Wir nehmen den Schutz deiner Daten sehr ernst. Mehr Infos findest du in der Datenschutzerklärung.',
        ),
        const SizedBox(height: 12),
        _btn('Datenschutzerklärung lesen', () {}, c: Colors.blue),
      ],
    ),
  );
}

void showDeleteAccountSheetNew(BuildContext context) {
  final t = Theme.of(context);

  showTTGBottomSheet(
    context: context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Account löschen', style: t.textTheme.titleMedium),
        const SizedBox(height: 10),
        const Text(
          'Dieser Vorgang ist endgültig und kann nicht rückgängig gemacht werden.',
        ),
        const SizedBox(height: 12),
        _btn('Account löschen', () {}, c: Colors.red),
      ],
    ),
  );
}