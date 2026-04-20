import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final dark = t.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _Line()),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const Expanded(child: _Line()),
            ],
          ),
          const SizedBox(height: 12),
          _GlassBox(dark: dark, children: children),
        ],
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final bool dark;
  final List<Widget> children;

  const _GlassBox({required this.dark, required this.children});

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: dark ? Colors.white.withOpacity(0.03) : Colors.white,
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(children: children),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: dark
          ? BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: box,
      )
          : box,
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFFE10600), Colors.transparent],
        ),
      ),
    );
  }
}