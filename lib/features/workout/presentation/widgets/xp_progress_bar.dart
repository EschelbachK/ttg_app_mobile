import 'package:flutter/material.dart';

class XpProgressBar extends StatelessWidget {
  final int xp;
  final int level;

  const XpProgressBar({
    super.key,
    required this.xp,
    required this.level,
  });

  int _xpForNextLevel(int level) {
    final safeLevel = level <= 0 ? 1 : level;
    return safeLevel * 1000;
  }

  @override
  Widget build(BuildContext context) {
    final nextLevelXp = _xpForNextLevel(level);
    final progress = (xp % nextLevelXp) / nextLevelXp;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEVEL ${level <= 0 ? 1 : level}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0, 1)),
            duration: const Duration(milliseconds: 1200),
            builder: (context, val, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: val,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor:
                  const AlwaysStoppedAnimation(Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '$xp XP',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}