import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/privacy_webview.dart';
import '../../../../core/auth/auth_provider.dart';
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
    final auth = ref.watch(authProvider);
    final user = auth.user;

    final textStyle = t.textTheme.bodyMedium?.copyWith(
      color: Colors.white.withOpacity(0.7),
      height: 1.4,
    );

    return Column(
      children: [
        if (user != null) _userHeader(user.username, user.email),

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

        SettingsTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () async {
            await ref.read(authProvider.notifier).logout();
          },
        ),
      ],
    );
  }

  Widget _userHeader(String name, String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 22, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white)),
              Text(email,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ],
      ),
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