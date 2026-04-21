import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/error/global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);
const kTextColor = Colors.white;
const kScale = 0.8;
double s(double v) => v * kScale;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);

    try {
      await ref.read(authProvider.notifier).login(
        email.text.trim(),
        password.text.trim(),
      );

      if (context.mounted) context.go('/dashboard');
    } catch (e) {
      final err = GlobalErrorHandler.handle(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message)));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(s(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Input("E-Mail", email),
                  SizedBox(height: s(16)),
                  _Input("Passwort", password, obscure: true),
                  SizedBox(height: s(28)),

                  _Button("Einloggen", loading ? null : _login),

                  SizedBox(height: s(18)),

                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Text(
                      "Kein Account? Registrieren",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  SizedBox(height: s(12)),

                  GestureDetector(
                    onTap: () => context.go('/forgot-password'),
                    child: Text(
                      "Passwort vergessen?",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  const _Input(this.hint, this.controller, {this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _Button(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.6 : 1,
        child: Container(
          width: double.infinity,
          height: s(52),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kPrimaryRed,
            borderRadius: BorderRadius.circular(s(30)),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}