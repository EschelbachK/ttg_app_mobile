import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import '../../models/exercise.dart';
import '../../models/exercise_set.dart';

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

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    final keyboard = ref.watch(settingsProvider).keyboardMode;

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

                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: e.sets.length,
                      onReorder: (o, n) {
                        if (n > o) n--;
                        final list = [...e.sets];
                        final item = list.removeAt(o);
                        list.insert(n, item);
                        _update(e.copyWith(sets: list));
                      },
                      itemBuilder: (_, i) {
                        final s = e.sets[i];

                        return Padding(
                          key: ValueKey("$i-${s.hashCode}"),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(.08)),
                              color: Colors.black.withOpacity(.25),
                            ),
                            child: Row(
                              children: [
                                Text("#${i + 1}", style: const TextStyle(color: Colors.white54)),
                                const SizedBox(width: 8),

                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _control(
                                          s.weight,
                                          "KG",
                                          keyboard,
                                              (v) => _set(e, i, v, s.reps),
                                              () => _set(e, i, s.weight - 1, s.reps),
                                              () => _set(e, i, s.weight + 1, s.reps),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: _control(
                                          s.reps.toDouble(),
                                          "WDH",
                                          keyboard,
                                              (v) => _set(e, i, s.weight, v.toInt()),
                                              () => _set(e, i, s.weight, s.reps - 1),
                                              () => _set(e, i, s.weight, s.reps + 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 6),

                                GestureDetector(
                                  onTap: () {
                                    final list = [...e.sets]..removeAt(i);
                                    _update(e.copyWith(sets: list));
                                  },
                                  child: const Icon(Icons.close, color: Colors.white38, size: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _control(
      double v,
      String unit,
      bool keyboard,
      Function(double) onChanged,
      VoidCallback minus,
      VoidCallback plus,
      ) {
    if (keyboard) {
      return TextFormField(
        initialValue: unit == "KG" ? v.toStringAsFixed(1) : v.toInt().toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: unit == "KG"),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
        inputFormatters: unit == "KG"
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
            : [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) {
          final parsed = double.tryParse(val);
          if (parsed != null) onChanged(parsed);
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _btn("-", minus),
        const SizedBox(width: 6),
        Text(
          unit == "KG" ? v.toStringAsFixed(1) : v.toInt().toString(),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 6),
        _btn("+", plus),
      ],
    );
  }

  Widget _btn(String t, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(t, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}