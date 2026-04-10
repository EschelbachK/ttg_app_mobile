import 'package:flutter/material.dart';

class TtgBackground extends StatelessWidget {
  final Widget child;

  const TtgBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/dashboard_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.75),
          ),
        ),
        child,
      ],
    );
  }
}