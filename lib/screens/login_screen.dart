import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_state_provider.dart';
import '../../../core/error/core_global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);
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

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Input(
                    "E-Mail",
                    email,
                    type: TextInputType.emailAddress,
                  ),
                  SizedBox(height: s(14)),
                  _Input(
                    "Passwort",
                    password,
                    obscure: true,
                  ),
                  SizedBox(height: s(24)),

                  _Button("Einloggen", loading ? null : _login),

                  SizedBox(height: s(16)),

                  _Link(
                    "Kein Account? Registrieren",
                        () => context.go('/register'),
                  ),

                  SizedBox(height: s(8)),

                  _Link(
                    "Passwort vergessen?",
                        () => context.go('/forgot-password'),
                    small: true,
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
  final TextInputType? type;

  const _Input(
      this.hint,
      this.controller, {
        this.obscure = false,
        this.type,
      });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
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
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.5 : 1,
        child: Container(
          width: double.infinity,
          height: s(50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kPrimaryRed,
            borderRadius: BorderRadius.circular(s(28)),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool small;

  const _Link(this.text, this.onTap, {this.small = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: small ? 13 : 14,
        ),
      ),
    );
  }
}