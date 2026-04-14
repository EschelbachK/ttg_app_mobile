import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class AddSetCTA extends StatelessWidget {
  final VoidCallback onTap;

  const AddSetCTA({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kPrimaryRed.withOpacity(0.6)),
              gradient: LinearGradient(
                colors: [
                  kPrimaryRed.withOpacity(0.15),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: kPrimaryRed, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'SATZ HINZUFÜGEN',
                    style: TextStyle(
                      color: kPrimaryRed,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}