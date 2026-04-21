import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/error/global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);
const kTextColor = Colors.white;
const kScale = 0.8;
double s(double v) => v * kScale;

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final email = TextEditingController();
  bool loading = false;

  Future<void> _send() async {
    setState(() => loading = true);

    try {
      await ref.read(authServiceProvider).forgotPassword(
        email.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-Mail wurde gesendet")),
        );
        context.go('/login');
      }
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
                  const Text(
                    "Passwort zurücksetzen",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: s(20)),

                  _Input("E-Mail", email),

                  SizedBox(height: s(28)),

                  _Button("Link senden", loading ? null : _send),

                  SizedBox(height: s(18)),

                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      "Zurück zum Login",
                      style: TextStyle(color: Colors.white70),
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

  const _Input(this.hint, this.controller);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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