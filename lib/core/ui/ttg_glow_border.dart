import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class TTGGlowBorder extends StatelessWidget {
  final Widget child;
  final double height;
  final EdgeInsets padding;

  const TTGGlowBorder({
    super.key,
    required this.child,
    this.height = 2,
    this.padding = const EdgeInsets.only(bottom: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        Padding(
          padding: padding,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimaryRed.withOpacity(0),
                  kPrimaryRed,
                  kPrimaryRed.withOpacity(0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryRed.withOpacity(0.4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}