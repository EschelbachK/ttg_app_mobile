import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class TTGGlowBorder extends StatelessWidget {
  final Widget child;
  final double height;

  const TTGGlowBorder({
    super.key,
    required this.child,
    this.height = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 12,
          right: 12,
          bottom: 0,
          child: IgnorePointer(
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
        ),
      ],
    );
  }
}