import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import '../../models/exercise.dart';
import '../../models/exercise_set.dart';

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback? onDelete;

  const ExerciseTile({super.key, required this.exercise, this.onDelete});

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool open = true;
  int? dragging;

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;

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
                            onTap: () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "",
                                barrierColor: Colors.black.withOpacity(.7),
                                transitionDuration: const Duration(milliseconds: 200),
                                pageBuilder: (_, __, ___) => const SizedBox(),
                                transitionBuilder: (context, animation, _, __) {
                                  final scale = Tween(begin: 0.9, end: 1.0).animate(
                                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                                  );

                                  return Transform.scale(
                                    scale: scale.value,
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: 300,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(.95),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.white.withOpacity(.08)),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Übung löschen",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  "Willst du diese Übung wirklich löschen?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Divider(color: Colors.white.withOpacity(.08), height: 1),
                                                const SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () => Navigator.pop(context),
                                                        child: Container(
                                                          height: 44,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            border: Border.all(
                                                              color: Colors.white.withOpacity(.08),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            "Abbrechen",
                                                            style: TextStyle(
                                                              color: Colors.white54,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          widget.onDelete?.call();
                                                        },
                                                        child: Container(
                                                          height: 44,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            color: AppTheme.primaryRed,
                                                          ),
                                                          child: const Text(
                                                            "Löschen",
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.close, color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (open) ...[
                    const SizedBox(height: 8),
                    Container(
                      height: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(.3),
                        border: Border.all(color: Colors.white.withOpacity(.06)),
                      ),
                      child: const Center(
                        child: Text("Übungsbild", style: TextStyle(color: Colors.white38)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: e.sets.length,
                      onReorderStart: (i) {
                        HapticFeedback.mediumImpact();
                        setState(() => dragging = i);
                      },
                      onReorderEnd: (_) => setState(() => dragging = null),
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex--;
                        final list = [...e.sets];
                        final item = list.removeAt(oldIndex);
                        list.insert(newIndex, item);
                        setState(() {
                          e.sets
                            ..clear()
                            ..addAll(list);
                        });
                      },
                      itemBuilder: (_, i) {
                        final s = e.sets[i];
                        final active = dragging == i;

                        return Padding(
                          key: ValueKey("${s.hashCode}-$i"),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Transform.scale(
                            scale: active ? 1.04 : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: active
                                    ? [
                                  BoxShadow(
                                    color: AppTheme.primaryRed.withOpacity(.35),
                                    blurRadius: 20,
                                  )
                                ]
                                    : [],
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(.08)),
                                  color: Colors.black.withOpacity(.25),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "#${i + 1}",
                                      style: const TextStyle(color: Colors.white54),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _control(
                                              s.weight,
                                              "KG",
                                                  () {
                                                setState(() {
                                                  e.sets[i] = ExerciseSet(
                                                    weight: (s.weight - 1).clamp(0, 999).toDouble(),
                                                    reps: s.reps,
                                                  );
                                                });
                                              },
                                                  () {
                                                setState(() {
                                                  e.sets[i] = ExerciseSet(
                                                    weight: s.weight + 1,
                                                    reps: s.reps,
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: _control(
                                              s.reps.toDouble(),
                                              "WDH",
                                                  () {
                                                setState(() {
                                                  e.sets[i] = ExerciseSet(
                                                    weight: s.weight,
                                                    reps: (s.reps - 1).clamp(0, 999),
                                                  );
                                                });
                                              },
                                                  () {
                                                setState(() {
                                                  e.sets[i] = ExerciseSet(
                                                    weight: s.weight,
                                                    reps: s.reps + 1,
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          e.sets.removeAt(i);
                                        });
                                      },
                                      child: const Icon(Icons.close, color: Colors.white38, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            e.sets.add(
                              ExerciseSet(
                                weight: e.sets.isNotEmpty ? e.sets.last.weight : 0,
                                reps: e.sets.isNotEmpty ? e.sets.last.reps : 0,
                              ),
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.primaryRed),
                          ),
                          child: const Center(
                            child: Text(
                              "+ SATZ HINZUFÜGEN",
                              style: TextStyle(
                                color: AppTheme.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _control(double v, String unit, VoidCallback minus, VoidCallback plus) {
    final isKg = unit == "KG";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _btn("-", minus),
        const SizedBox(width: 6),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(
                  isKg ? v.toStringAsFixed(1) : v.toInt().toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 3),
                Text(
                  unit,
                  style: const TextStyle(
                    color: AppTheme.primaryRed,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
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
          child: Text(
            t,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}