import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/settings/settings_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import '../../models/exercise.dart';
import '../../models/exercise_set.dart';

const kPrimaryRed = Color(0xFFE10600);

class ExerciseTile extends ConsumerStatefulWidget {
  final Exercise exercise;
  final VoidCallback? onDelete;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.onDelete,
  });

  @override
  ConsumerState<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends ConsumerState<ExerciseTile> {
  bool open = false;

  void _update(Exercise updated) {
    setState(() {
      widget.exercise.sets
        ..clear()
        ..addAll(updated.sets);
    });
  }

  void _set(Exercise e, int i, double w, int r) {
    final list = [...e.sets];
    list[i] = ExerciseSet(weight: w, reps: r);
    _update(e.copyWith(sets: list));
  }

  void _addSet() {
    final e = widget.exercise;
    final list = [...e.sets, ExerciseSet(weight: 0, reps: 0)];
    _update(e.copyWith(sets: list));
  }

  double _normalize(double v) => (v * 2).round() / 2;

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    final settings = ref.watch(settingsProvider);
    final keyboard = settings.keyboardMode;
    final step = settings.weightStep;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.04),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => open = !open),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            open
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 12, height: 2, color: AppTheme.primaryRed),
                                  const SizedBox(width: 6),
                                  Text(
                                    e.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(width: 12, height: 2, color: AppTheme.primaryRed),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: const Icon(Icons.close, color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (open) ...[
                    const SizedBox(height: 8),

                    ...List.generate(e.sets.length, (i) {
                      final s = e.sets[i];

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '#${i + 1}',
                                style: const TextStyle(color: Colors.white38, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _stepper(
                                      s.weight,
                                      true,
                                      'KG',
                                      keyboard,
                                          (v) => _set(e, i, v, s.reps),
                                          () => _set(e, i, _normalize(s.weight - step), s.reps),
                                          () => _set(e, i, _normalize(s.weight + step), s.reps),
                                    ),
                                  ),
                                  Expanded(
                                    child: _stepper(
                                      s.reps.toDouble(),
                                      false,
                                      'WDH',
                                      keyboard,
                                          (v) => _set(e, i, s.weight, v.toInt()),
                                          () => _set(e, i, s.weight, s.reps - 1),
                                          () => _set(e, i, s.weight, s.reps + 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final list = [...e.sets]..removeAt(i);
                                _update(e.copyWith(sets: list));
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: const Icon(Icons.close, size: 16, color: Colors.white54),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _addSet,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kPrimaryRed.withOpacity(0.9)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

                    const SizedBox(height: 6),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepper(
      double value,
      bool isDecimal,
      String suffix,
      bool keyboard,
      Function(double) onChanged,
      VoidCallback onMinus,
      VoidCallback onPlus,
      ) {
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
          child: keyboard
              ? SizedBox(
            width: 50,
            child: TextField(
              controller: TextEditingController(
                text: isDecimal
                    ? value.toStringAsFixed(1)
                    : value.toInt().toString(),
              ),
              keyboardType:
              TextInputType.numberWithOptions(decimal: isDecimal),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
              inputFormatters: isDecimal
                  ? [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'))
              ]
                  : [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) onChanged(parsed);
              },
            ),
          )
              : Row(
            children: [
              Text(
                isDecimal
                    ? value.toStringAsFixed(1)
                    : value.toInt().toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                suffix,
                style: const TextStyle(
                  color: kPrimaryRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        btn(Icons.add, onPlus),
      ],
    );
  }
}