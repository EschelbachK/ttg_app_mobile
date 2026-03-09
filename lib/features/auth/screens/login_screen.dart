import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';

const kPrimaryRed = Color(0xFFE10600); // Blutrot wie Logo-2
const kTextColor = Colors.white;
const kScale = 0.75;
double s(double v) => v * kScale;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              alignment: const Alignment(0.1, -1.0),
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
                  SizedBox(height: screenHeight * 0.44),

                  const _GlowInput(hint: 'E-Mail-Adresse'),
                  SizedBox(height: s(22)),

                  const _GlowInput(hint: 'Passwort', obscure: true),
                  SizedBox(height: s(36)),

                  _LoginButton(
                    onTap: () {
                      ref.read(authProvider.notifier).login(
                        accessToken: 'dev_access',
                        refreshToken: 'dev_refresh',
                      );
                      context.go('/dashboard');
                    },
                  ),

                  SizedBox(height: s(18)),
                  Text(
                    'oder',
                    style: TextStyle(
                      color: kTextColor.withOpacity(0.7),
                      fontSize: s(14),
                    ),
                  ),
                  SizedBox(height: s(18)),

                  const _GlassButton(
                    icon: Icons.person,
                    label: 'kostenlosen Account erstellen',
                  ),
                  SizedBox(height: s(10)),

                  const _GlassButton(
                    icon: Icons.key,
                    label: 'Passwort vergessen?',
                  ),

                  SizedBox(height: s(22)),
                  const _LanguageSwitch(),

                  SizedBox(height: s(40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LoginButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: s(56),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔥 dezenter Außen-Glow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(s(40)),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryRed.withOpacity(0.45),
                    blurRadius: s(22),
                    spreadRadius: s(1),
                  ),
                ],
              ),
            ),

            // 💎 Glas-Körper
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(s(40)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5A0000),
                    Color(0xFF2A0000),
                  ],
                ),
                border: Border.all(
                  color: kPrimaryRed,
                  width: s(1.6),
                ),
              ),
            ),

            // ✨ roter Glas-Schimmer (Linien-Stil)
            Container(
              margin: EdgeInsets.all(s(2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(s(38)),
                gradient: LinearGradient(
                  colors: [
                    kPrimaryRed.withOpacity(0.55),
                    kPrimaryRed.withOpacity(0.85),
                    kPrimaryRed.withOpacity(0.55),
                  ],
                ),
              ),
            ),

            // ✨ obere Lichtkante
            Positioned(
              top: s(4),
              left: s(24),
              right: s(24),
              child: Container(
                height: s(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(s(20)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.35),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),

            // 🧩 Inhalt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login,
                    size: s(20),
                    color: Colors.white.withOpacity(0.95)),
                SizedBox(width: s(10)),
                Text(
                  'einloggen',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: s(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GlassButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: s(18)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(s(36)),
        color: Colors.white.withOpacity(0.10), // weniger transparent
        border: Border.all(
          color: Colors.white.withOpacity(0.28),
          width: s(1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: s(12),
            offset: Offset(0, s(4)),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: s(20), color: kTextColor.withOpacity(0.92)),
          SizedBox(width: s(10)),
          Text(
            label,
            style: TextStyle(
              color: kTextColor.withOpacity(0.92),
              fontSize: s(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSwitch extends StatefulWidget {
  const _LanguageSwitch();

  @override
  State<_LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<_LanguageSwitch> {
  bool isGerman = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(s(4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(s(32)),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white24, width: s(1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangButton(
            label: 'ENGLISH',
            flag: '🇬🇧',
            active: !isGerman,
            onTap: () => setState(() => isGerman = false),
          ),
          _LangButton(
            label: 'DEUTSCH',
            flag: '🇩🇪',
            active: isGerman,
            onTap: () => setState(() => isGerman = true),
          ),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final String flag;
  final bool active;
  final VoidCallback onTap;

  const _LangButton({
    required this.label,
    required this.flag,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          horizontal: s(18),
          vertical: s(10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(s(28)),
          color: active
              ? Colors.white.withOpacity(0.14)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag),
            SizedBox(width: s(8)),
            Text(
              label,
              style: TextStyle(
                color: kTextColor.withOpacity(0.92),
                fontWeight: FontWeight.w600,
                fontSize: s(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowInput extends StatefulWidget {
  final String hint;
  final bool obscure;

  const _GlowInput({
    required this.hint,
    this.obscure = false,
  });

  @override
  State<_GlowInput> createState() => _GlowInputState();
}

class _GlowInputState extends State<_GlowInput> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          focusNode: _focusNode,
          obscureText: widget.obscure,
          cursorColor: kPrimaryRed,
          style: TextStyle(
            color: kTextColor,
            fontSize: s(18),
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: kTextColor.withOpacity(0.7),
              fontSize: s(16),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: s(10)),
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
            boxShadow: _focused
                ? [
              BoxShadow(
                color: kPrimaryRed.withOpacity(0.45),
                blurRadius: s(10),
                spreadRadius: s(0.5),
              ),
            ]
                : [],
          ),
        ),
      ],
    );
  }
}