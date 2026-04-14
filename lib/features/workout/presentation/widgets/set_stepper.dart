import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class SetStepper extends StatelessWidget {
  final String value;
  final String suffix;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const SetStepper({
    super.key,
    required this.value,
    required this.suffix,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btn(Icons.remove, onMinus),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Text(suffix,
                  style: const TextStyle(
                      color: kPrimaryRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        btn(Icons.add, onPlus),
      ],
    );
  }
}