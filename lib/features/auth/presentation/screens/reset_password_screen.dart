import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service_provider.dart';
import '../../../../core/error/core_global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);
const kScale = 0.8;
double s(double v) => v * kScale;

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool loading = false;

  bool get valid =>
      password.text.length >= 8 &&
          password.text == confirmPassword.text;

  @override
  void dispose() {
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwörter stimmen nicht überein")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await ref.read(authServiceProvider).resetPassword(
        widget.token,
        password.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwort erfolgreich geändert")),
        );
        context.go('/login');
      }
    } catch (e) {
      final err = GlobalErrorHandler.handle(e);

      if (context.mounted) {
        String msg = err.message;

        final lower = msg.toLowerCase();

        if (lower.contains("token") && lower.contains("invalid")) {
          msg = "Link ungültig";
        } else if (lower.contains("token") && lower.contains("expired")) {
          msg = "Link abgelaufen";
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
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
                  const Text(
                    "Neues Passwort setzen",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  SizedBox(height: s(20)),

                  _Input("Neues Passwort", password, obscure: true),

                  SizedBox(height: s(16)),

                  _Input("Passwort bestätigen", confirmPassword, obscure: true),

                  SizedBox(height: s(24)),

                  _Button("Passwort speichern", loading ? null : _reset),

                  SizedBox(height: s(16)),

                  _Link(
                    "Zurück zum Login",
                        () => context.go('/login'),
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

  const _Input(this.hint, this.controller, {this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
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