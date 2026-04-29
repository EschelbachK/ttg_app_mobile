import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/privacy_webview.dart';
import '../../../../core/auth/auth_state_provider.dart';
import 'settings_tile.dart';

class AccountExpand extends ConsumerStatefulWidget {
  const AccountExpand({super.key});

  @override
  ConsumerState<AccountExpand> createState() => _AccountExpandState();
}

class _AccountExpandState extends ConsumerState<AccountExpand> {
  int open = -1;
  void toggle(int i) => setState(() => open = open == i ? -1 : i);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final style = t.textTheme.bodyMedium?.copyWith(
      color: Colors.white.withOpacity(0.7),
      height: 1.4,
    );

    return Column(
      children: [
        _tile(Icons.lock, 'Passwort', 0),
        if (open == 0) _wrap(_password(style)),

        _tile(Icons.privacy_tip, 'Datenschutz', 1),
        if (open == 1) _wrap(_privacy(context, style)),

        _tile(Icons.warning_amber, 'Account löschen', 2),
        if (open == 2) _wrap(_delete(style)),

        SettingsTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () => ref.read(authProvider.notifier).logout(),
        ),
      ],
    );
  }

  Widget _tile(IconData icon, String title, int i) => SettingsTile(
    icon: icon,
    title: title,
    onTap: () => toggle(i),
    trailing: Icon(open == i ? Icons.expand_less : Icons.expand_more),
  );

  Widget _wrap(Widget c) =>
      Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: c);

  Widget _password(TextStyle? s) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Hier kannst du ein sicheres Login-Passwort vergeben.', style: s),
      const SizedBox(height: 16),
      _input('Neues Passwort'),
      const SizedBox(height: 12),
      _input('Neues Passwort wiederholen'),
      const SizedBox(height: 16),
      _btn('Neues Passwort speichern'),
    ],
  );

  Widget _privacy(BuildContext c, TextStyle? s) => Column(
    children: [
      Text(
        'Wir nehmen den Schutz deiner Daten sehr ernst.\nMehr Infos findest du in der Datenschutzerklärung.',
        textAlign: TextAlign.center,
        style: s,
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

  Widget _delete(TextStyle? s) => Column(
    children: [
      Text(
        'Dein Account wird 30 Tage deaktiviert.\nDanach wird er endgültig gelöscht.',
        textAlign: TextAlign.center,
        style: s,
      ),
      const SizedBox(height: 16),
      _btn('Account deaktivieren', color: AppTheme.primaryRed),
    ],
  );

  Widget _input(String h) => TextField(
    style: const TextStyle(color: Colors.white),
    decoration: const InputDecoration(
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    ).copyWith(hintText: h),
  );

  Widget _btn(String t, {Color? color, VoidCallback? onTap}) {
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
          child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}