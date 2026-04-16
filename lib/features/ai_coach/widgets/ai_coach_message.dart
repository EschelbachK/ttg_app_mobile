import 'package:flutter/material.dart';

enum CoachState {
  positive,
  warning,
  negative,
  neutral,
}

class AICoachMessage extends StatefulWidget {
  final String message;
  final CoachState state;

  const AICoachMessage({
    super.key,
    required this.message,
    required this.state,
  });

  @override
  State<AICoachMessage> createState() => _AICoachMessageState();
}

class _AICoachMessageState extends State<AICoachMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Color _color() {
    switch (widget.state) {
      case CoachState.positive:
        return const Color(0xFF22C55E);
      case CoachState.warning:
        return const Color(0xFFF59E0B);
      case CoachState.negative:
        return const Color(0xFFEF4444);
      case CoachState.neutral:
        return const Color(0xFFE10600);
    }
  }

  IconData _icon() {
    switch (widget.state) {
      case CoachState.positive:
        return Icons.trending_up;
      case CoachState.warning:
        return Icons.warning_amber_rounded;
      case CoachState.negative:
        return Icons.close;
      case CoachState.neutral:
        return Icons.bolt;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final containerGlow = 0.2 + (_controller.value * 0.25);
        final iconPulse = 0.9 + (_controller.value * 0.2);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.15),
                Colors.black.withOpacity(0.25),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: color.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(containerGlow),
                blurRadius: 20,
                spreadRadius: -3,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: iconPulse,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.9),
                        color.withOpacity(0.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.7),
                        blurRadius: 14,
                        spreadRadius: -2,
                      )
                    ],
                  ),
                  child: Icon(
                    _icon(),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.message.replaceFirst("😈: ", ""),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}