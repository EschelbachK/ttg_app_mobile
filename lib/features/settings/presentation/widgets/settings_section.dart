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
    final isDark = t.brightness == Brightness.dark;
    const c = Color(0xFFE10600);

    Widget container = Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(children: children),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _Line(color: c)),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const Expanded(child: _Line(color: c)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: isDark
                ? BackdropFilter(
              filter:
              ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: container,
            )
                : container,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final Color color;
  const _Line({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, color, Colors.transparent],
        ),
      ),
    );
  }
}