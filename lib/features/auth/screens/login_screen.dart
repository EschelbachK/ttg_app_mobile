import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/error/global_error_handler.dart';

const kPrimaryRed = Color(0xFFE10600);
const kTextColor = Colors.white;
const kScale = 0.75;
double s(double v) => v * kScale;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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

                  _GlowInput(
                    hint: 'E-Mail-Adresse',
                    controller: emailController,
                  ),

                  SizedBox(height: s(22)),

                  _GlowInput(
                    hint: 'Passwort',
                    obscure: true,
                    controller: passwordController,
                  ),

                  SizedBox(height: s(36)),

                  _LoginButton(
                    onTap: isLoading
                        ? null
                        : () async {
                      setState(() => isLoading = true);

                      try {
                        final dio = ref.read(dioProvider);
                        final authService = AuthService(dio);

                        final response = await authService.login(
                          emailController.text,
                          passwordController.text,
                        );

                        await ref.read(authProvider.notifier).login(
                          accessToken: response.accessToken,
                          refreshToken: response.refreshToken,
                        );

                        if (context.mounted) {
                          context.go('/dashboard');
                        }
                      } catch (e) {
                        final error = GlobalErrorHandler.handle(e);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => isLoading = false);
                        }
                      }
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

                  SizedBox(height: s(24)),

                  const _LanguageSwitch(),

                  SizedBox(height: s(40)),
                ],
              ),
            ),
          ),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class _GlowInput extends StatefulWidget {
  final String hint;
  final bool obscure;
  final TextEditingController controller;

  const _GlowInput({
    required this.hint,
    required this.controller,
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
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscure,
          cursorColor: kPrimaryRed,
          style: TextStyle(color: kTextColor, fontSize: s(18)),
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
              )
            ]
                : [],
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _LoginButton({required this.onTap});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Colors.white, size: s(20)),
                  SizedBox(width: s(10)),
                  Text(
                    'einloggen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: s(20)),
          SizedBox(width: s(10)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: s(16),
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
        color: Colors.white.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _lang('🇬🇧 ENGLISH', !isGerman, () {
            setState(() => isGerman = false);
          }),
          _lang('🇩🇪 DEUTSCH', isGerman, () {
            setState(() => isGerman = true);
          }),
        ],
      ),
    );
  }

  Widget _lang(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: s(18),
          vertical: s(10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(s(28)),
          color: active
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: s(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}