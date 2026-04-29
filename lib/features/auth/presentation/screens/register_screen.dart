import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service_provider.dart';
import '../../../../core/error/core_global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  bool accept = false;

  bool get valid =>
      email.text.isNotEmpty &&
          username.text.isNotEmpty &&
          password.text.length >= 8 &&
          accept;

  Future<void> _register() async {
    if (!valid) return;
    setState(() => loading = true);
    try {
      await ref.read(authServiceProvider).register(
        email.text.trim(),
        username.text.trim(),
        password.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Check deine Email zur Bestätigung"),
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      GlobalErrorHandler.handle(e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _openTerms() => context.go('/terms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/dashboard_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.75)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: kPrimaryRed.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryRed.withOpacity(0.2),
                      blurRadius: 40,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "-Account erstellen-",
                        style: TextStyle(
                          color: kPrimaryRed,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        "Dein Körper. Dein Fortschritt.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        "Starte jetzt und hol das Maximum aus dir raus!",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _Label("Benutzername"),
                    _Input("Username", username, Icons.person_outline),
                    const SizedBox(height: 14),
                    const _Label("E-Mail"),
                    _Input("Email address", email, Icons.mail_outline),
                    const SizedBox(height: 14),
                    const _Label("Passwort"),
                    _Input("Enter Password", password, Icons.lock_outline,
                        obscure: true, suffix: Icons.visibility_off),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Checkbox(
                          value: accept,
                          activeColor: kPrimaryRed,
                          side: const BorderSide(color: Colors.white54),
                          onChanged: (v) =>
                              setState(() => accept = v ?? false),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                              children: [
                                const TextSpan(
                                    text: "Ich akzeptiere die "),
                                TextSpan(
                                  text: "Nutzungsbedingungen",
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _openTerms,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: valid && !loading ? _register : null,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B0000), kPrimaryRed],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          "Registrieren",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("ODER",
                              style: TextStyle(color: Colors.white54)),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _SocialImage("assets/icons/google.png"),
                        SizedBox(width: 14),
                        _SocialImage("assets/icons/instagram.png"),
                        SizedBox(width: 14),
                        _SocialImage("assets/icons/facebook.png"),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style:
                          const TextStyle(color: Colors.white54),
                          children: [
                            const TextSpan(
                                text: "Schon einen Account? "),
                            TextSpan(
                              text: "Einloggen",
                              style: const TextStyle(
                                color: kPrimaryRed,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => context.go('/login'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final IconData? suffix;

  const _Input(this.hint, this.controller, this.icon,
      {this.obscure = false, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryRed, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style:
              const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null)
            Icon(suffix, color: kPrimaryRed, size: 18),
        ],
      ),
    );
  }
}

class _SocialImage extends StatelessWidget {
  final String path;
  const _SocialImage(this.path);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
      ),
      child: Image.asset(path),
    );
  }
}