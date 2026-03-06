import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // 🔥 Logo / Title
              const Center(
                child: Text(
                  'TRAINTOGAIN',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Bitte logge dich ein oder erstelle einen Account.\n'
                    'TrainToGain ist und bleibt kostenlos.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // 🌍 Language Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LangButton(
                    label: 'ENGLISH',
                    active: false,
                  ),
                  const SizedBox(width: 12),
                  _LangButton(
                    label: 'DEUTSCH',
                    active: true,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ✉ Email
              const TextField(
                decoration: InputDecoration(
                  hintText: 'E-Mail-Adresse',
                ),
              ),

              const SizedBox(height: 12),

              // 🔒 Password
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Passwort',
                ),
              ),

              const SizedBox(height: 24),

              // 🔐 Login Button
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).login(
                    accessToken: 'dev_access',
                    refreshToken: 'dev_refresh',
                  );
                  context.go('/dashboard');
                },
                icon: const Icon(Icons.login),
                label: const Text('einloggen'),
              ),

              const SizedBox(height: 12),

              const Center(child: Text('oder')),

              const SizedBox(height: 12),

              // 🆕 Register Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A4C93),
                ),
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('kostenlosen Account erstellen'),
              ),

              const SizedBox(height: 12),

              // ❓ Help Buttons
              _SecondaryButton(
                icon: Icons.key,
                label: 'Passwort vergessen?',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              _SecondaryButton(
                icon: Icons.mail,
                label: 'hilfe@traintogain.app',
                onTap: () {},
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================
// Widgets
// ============================

class _LangButton extends StatelessWidget {
  final String label;
  final bool active;

  const _LangButton({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF7B1E3A) : const Color(0xFF1B1F24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F36),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}