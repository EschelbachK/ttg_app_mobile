import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';

const kPrimaryRed = Color(0xFFE10600);

class SetRow extends ConsumerStatefulWidget {
  final int index;
  final String exerciseId;
  final String setId;
  final double weight;
  final int reps;
  final bool? completed;

  const SetRow({
    super.key,
    required this.index,
    required this.exerciseId,
    required this.setId,
    required this.weight,
    required this.reps,
    required this.completed,
  });

  @override
  ConsumerState<SetRow> createState() => _SetRowState();
}

class _SetRowState extends ConsumerState<SetRow> {
  bool _locked = false;

  void _unlock() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(workoutProvider.notifier);
    final isCompleted = widget.completed == true;

    void update({double? w, int? r, bool? c}) {
      if (_locked) return;
      _locked = true;

      controller.updateSet(
        exerciseId: widget.exerciseId,
        setId: widget.setId,
        weight: w ?? widget.weight,
        reps: r ?? widget.reps,
        completed: c ?? widget.completed,
      );

      _unlock();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted ? kPrimaryRed : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '#${widget.index + 1}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _Stepper(
                    value: widget.weight.toStringAsFixed(1),
                    suffix: 'KG',
                    onMinus: () => update(w: widget.weight - 2.5),
                    onPlus: () => update(w: widget.weight + 2.5),
                  ),
                ),
                Expanded(
                  child: _Stepper(
                    value: widget.reps.toString(),
                    suffix: 'WDH',
                    onMinus: () => update(r: widget.reps - 1),
                    onPlus: () => update(r: widget.reps + 1),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_locked) return;
              HapticFeedback.mediumImpact();
              update(c: !isCompleted);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted ? kPrimaryRed : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCompleted ? kPrimaryRed : Colors.white24,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 16,
                color: isCompleted ? Colors.white : Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final String value;
  final String suffix;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _Stepper({
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