import 'package:flutter/material.dart';

class RepsInputStepper extends StatelessWidget {
  final int value;
  final int step;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const RepsInputStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max = 100,
  });

  void _increment() {
    final newValue = (value + step).clamp(min, max);
    onChanged(newValue);
  }

  void _decrement() {
    final newValue = (value - step).clamp(min, max);
    onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(icon: Icons.remove, onTap: _decrement),
        Expanded(
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _StepperButton(icon: Icons.add, onTap: _increment),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}