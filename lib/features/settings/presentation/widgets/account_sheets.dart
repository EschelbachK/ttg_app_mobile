import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_sheet.dart';

Widget _field(BuildContext c, String hint, TextEditingController ctrl) {
  final t = Theme.of(c);
  final dark = t.brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: dark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: TextField(
      controller: ctrl,
      obscureText: true,
      style: TextStyle(
        color: dark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: dark ? Colors.white.withOpacity(0.35) : Colors.black.withOpacity(0.35),
        ),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget _btn(String text, VoidCallback onTap, {bool primary = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: primary ? AppTheme.primaryButtonGradient : null,
        color: primary ? null : Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
        _btn('Speichern', () => Navigator.pop(context), primary: true),
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
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        _btn(
          'Datenschutzerklärung lesen',
              () {
            Navigator.pop(context);
            context.push('/privacy');
          },
          primary: true,
        ),
      ],
    ),
  );
}

void showDeleteAccountSheetNew(BuildContext context) {
  final t = Theme.of(context);
  bool confirmed = false;

  showTTGBottomSheet(
    context: context,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Account löschen', style: t.textTheme.titleMedium),
            const SizedBox(height: 10),
            const Text(
              'Soft Delete aktiv: Dein Account wird deaktiviert und nach 30 Tagen endgültig gelöscht. Wiederherstellung innerhalb dieser Zeit möglich.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Checkbox(
                  value: confirmed,
                  onChanged: (v) => setState(() => confirmed = v ?? false),
                ),
                const Expanded(
                  child: Text('Ich verstehe die 30-Tage Wiederherstellung'),
                )
              ],
            ),

            const SizedBox(height: 10),

            _btn(
              'Account löschen',
              confirmed ? () {} : () {},
              primary: confirmed,
            ),
          ],
        );
      },
    ),
  );
}