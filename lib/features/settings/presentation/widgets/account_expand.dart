import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/privacy_webview.dart';
import 'settings_tile.dart';

class AccountExpand extends StatefulWidget {
  const AccountExpand({super.key});

  @override
  State<AccountExpand> createState() => _AccountExpandState();
}

class _AccountExpandState extends State<AccountExpand> {
  int open = -1;

  void toggle(int i) => setState(() => open = open == i ? -1 : i);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    final textStyle = t.textTheme.bodyMedium?.copyWith(
      color: Colors.white.withOpacity(0.7),
      height: 1.4,
    );

    return Column(
      children: [
        SettingsTile(
          icon: Icons.lock,
          title: 'Passwort',
          onTap: () => toggle(0),
          trailing: Icon(open == 0 ? Icons.expand_less : Icons.expand_more),
        ),
        if (open == 0) _wrap(_password(textStyle)),

        SettingsTile(
          icon: Icons.privacy_tip,
          title: 'Datenschutz',
          onTap: () => toggle(1),
          trailing: Icon(open == 1 ? Icons.expand_less : Icons.expand_more),
        ),
        if (open == 1) _wrap(_privacy(context, textStyle)),

        SettingsTile(
          icon: Icons.warning_amber,
          title: 'Account löschen',
          onTap: () => toggle(2),
          trailing: Icon(open == 2 ? Icons.expand_less : Icons.expand_more),
        ),
        if (open == 2) _wrap(_delete(textStyle)),
      ],
    );
  }

  Widget _wrap(Widget child) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
    child: child,
  );

  Widget _password(TextStyle? style) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hier kannst du ein sicheres Login-Passwort vergeben.',
        style: style,
      ),
      const SizedBox(height: 16),
      _input('Neues Passwort'),
      const SizedBox(height: 12),
      _input('Neues Passwort wiederholen'),
      const SizedBox(height: 16),
      _btn('Neues Passwort speichern'),
    ],
  );

  Widget _privacy(BuildContext c, TextStyle? style) => Column(
    children: [
      Text(
        'Wir nehmen den Schutz deiner Daten sehr ernst.\nMehr Infos findest du in der Datenschutzerklärung.',
        textAlign: TextAlign.center,
        style: style,
      ),
      const SizedBox(height: 16),
      _btn(
        'Datenschutzerklärung lesen',
        onTap: () => Navigator.push(
          c,
          MaterialPageRoute(builder: (_) => const PrivacyWebView()),
        ),
      ),
    ],
  );

  Widget _delete(TextStyle? style) => Column(
    children: [
      Text(
        'Dein Account wird 30 Tage deaktiviert.\nDanach wird er endgültig gelöscht.',
        textAlign: TextAlign.center,
        style: style,
      ),
      const SizedBox(height: 16),
      _btn('Account deaktivieren', color: AppTheme.primaryRed),
    ],
  );

  Widget _input(String hint) => TextField(
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );

  Widget _btn(String text, {Color? color, VoidCallback? onTap}) {
    final c = color ?? AppTheme.primaryRed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
}