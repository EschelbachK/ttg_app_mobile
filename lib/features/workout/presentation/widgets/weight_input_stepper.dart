import 'package:flutter/material.dart';

class WeightInputStepper extends StatelessWidget {
  final double value;
  final double step;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const WeightInputStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 2.5,
    this.min = 0,
    this.max = 500,
  });

  void _increment() {
    final newValue = (value + step).clamp(min, max).toDouble();
    onChanged(newValue);
  }

  void _decrement() {
    final newValue = (value - step).clamp(min, max).toDouble();
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
              value.toStringAsFixed(1),
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