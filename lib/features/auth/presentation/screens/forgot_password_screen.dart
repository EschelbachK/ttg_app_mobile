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
      await ref.read(authServiceProvider).forgotPassword(email.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wenn ein Account existiert, wurde eine Mail gesendet"),
          ),
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
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              alignment: const Alignment(0.1, -1),
              child: Transform.scale(
                scaleX: 0.85,
                scaleY: 1.09,
                child: Image.asset('assets/images/login_bg.png'),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: s(24)),
              child: Column(
                children: [
                  SizedBox(height: h * 0.44),

                  Text(
                    "PASSWORT ZURÜCKSETZEN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s(20),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: s(30)),

                  _GlowInput('E-Mail-Adresse', email),

                  SizedBox(height: s(36)),

                  _Button("Link senden", loading ? null : _send),

                  SizedBox(height: s(18)),

                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      "Zurück zum Login",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: s(14),
                      ),
                    ),
                  ),

                  SizedBox(height: s(40)),
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

class _GlowInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;

  const _GlowInput(this.hint, this.controller);

  @override
  State<_GlowInput> createState() => _GlowInputState();
}

class _GlowInputState extends State<_GlowInput> {
  final focus = FocusNode();
  bool active = false;

  @override
  void initState() {
    super.initState();
    focus.addListener(() => setState(() => active = focus.hasFocus));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          focusNode: focus,
          cursorColor: kPrimaryRed,
          style: TextStyle(color: kTextColor, fontSize: s(18)),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: kTextColor.withOpacity(0.7),
              fontSize: s(16),
            ),
            border: InputBorder.none,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: s(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kPrimaryRed.withOpacity(0),
                kPrimaryRed,
                kPrimaryRed.withOpacity(0),
              ],
            ),
            boxShadow: active
                ? [BoxShadow(color: kPrimaryRed.withOpacity(0.45), blurRadius: s(10))]
                : [],
          ),
        ),
      ],
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
          height: s(56),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(s(40)),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryRed.withOpacity(0.5),
                      blurRadius: s(25),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(s(40)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A0000), Color(0xFF2A0000)],
                  ),
                  border: Border.all(color: kPrimaryRed, width: s(1.6)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(s(2)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(s(38)),
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryRed.withOpacity(0.6),
                      kPrimaryRed,
                      kPrimaryRed.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}