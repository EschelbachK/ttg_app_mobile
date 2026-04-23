import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/error/global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);
const kScale = 0.8;
double s(double v) => v * kScale;

class VerifyInfoScreen extends ConsumerStatefulWidget {
  final String? email;

  const VerifyInfoScreen({super.key, this.email});

  @override
  ConsumerState<VerifyInfoScreen> createState() => _VerifyInfoScreenState();
}

class _VerifyInfoScreenState extends ConsumerState<VerifyInfoScreen> {
  bool loading = false;
  int cooldown = 0;

  Future<void> _resend() async {
    if (cooldown > 0) return;

    setState(() {
      loading = true;
      cooldown = 30;
    });

    try {
      if (widget.email != null && widget.email!.isNotEmpty) {
        await ref
            .read(authServiceProvider)
            .resendVerification(widget.email!);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wenn ein Account existiert, wurde eine Mail gesendet"),
          ),
        );
      }

      _startCooldown();
    } catch (e) {
      GlobalErrorHandler.handle(e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _startCooldown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() => cooldown--);
      return cooldown > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: s(28)),
              child: Column(
                children: [
                  SizedBox(height: h * 0.42),

                  Icon(
                    Icons.mark_email_read_outlined,
                    color: kPrimaryRed,
                    size: s(64),
                  ),

                  SizedBox(height: s(24)),

                  Text(
                    "E-Mail bestätigen",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s(22),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: s(12)),

                  Text(
                    "Bitte überprüfe dein Postfach\nund bestätige deine E-Mail-Adresse.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: s(14),
                    ),
                  ),

                  SizedBox(height: s(32)),

                  _Button("Zum Login", () => context.go('/login')),

                  SizedBox(height: s(16)),

                  GestureDetector(
                    onTap: (loading || cooldown > 0) ? null : _resend,
                    child: Text(
                      cooldown > 0
                          ? "Erneut senden in ${cooldown}s"
                          : "E-Mail erneut senden",
                      style: TextStyle(
                        color: cooldown > 0
                            ? Colors.white38
                            : kPrimaryRed,
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

class _Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _Button(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: s(52),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(s(30)),
          gradient: const LinearGradient(
            colors: [Color(0xFF5A0000), Color(0xFF2A0000)],
          ),
          border: Border.all(color: kPrimaryRed),
          boxShadow: [
            BoxShadow(
              color: kPrimaryRed.withOpacity(0.4),
              blurRadius: s(18),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: s(15),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}