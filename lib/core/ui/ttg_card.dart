import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TTGCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  const TTGCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}