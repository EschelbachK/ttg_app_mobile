import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ttg_confirm_dialog.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import '../../models/exercise.dart';
import '../../models/exercise_set.dart';

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback? onDelete;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.onDelete,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => open = !open),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center,
                              color: AppTheme.primaryRed, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(e.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Icon(
                            open
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _confirmDelete,
                            child: const Icon(Icons.close,
                                color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (open) ...[
                    _imagePreview(),
                    const SizedBox(height: 12),
                    _headerRow(),
                    const SizedBox(height: 8),
                    _setList(e),
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

  Widget _imagePreview() => Container(
    height: 150,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.black.withOpacity(0.25),
    ),
    alignment: Alignment.center,
    child: const Text("Übungsbild",
        style: TextStyle(color: Colors.white38)),
  );

  Widget _headerRow() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        SizedBox(width: 30),
        Expanded(
            child: Center(
                child: Text("SATZ",
                    style: TextStyle(color: Colors.white38)))),
        Expanded(
            child: Center(
                child: Icon(Icons.fitness_center,
                    size: 18, color: Colors.white38))),
        Expanded(
            child: Center(
                child: Icon(Icons.repeat,
                    size: 18, color: Colors.white38))),
      ],
    ),
  );

  Widget _setList(Exercise e) => ReorderableListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    buildDefaultDragHandles: false,
    itemCount: e.sets.length,
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
    itemBuilder: (_, i) =>
        _setRow(e.sets[i], i, key: ValueKey(i)),
  );

  Widget _setRow(ExerciseSet set, int index, {required Key key}) {
    final e = widget.exercise;

    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.03),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_indicator,
                color: Colors.white38),
          ),
          Expanded(
            child: Center(
              child: Text("${index + 1}",
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => _editValue(
                  "Gewicht",
                  set.weight.toInt(),
                      (v) => e.sets[index] =
                      ExerciseSet(weight: v.toDouble(), reps: set.reps),
                ),
                child: Text("${set.weight} kg",
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => _editValue(
                  "Wdh",
                  set.reps,
                      (v) => e.sets[index] =
                      ExerciseSet(weight: set.weight, reps: v),
                ),
                child: Text("${set.reps}",
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() async {
    if (widget.onDelete == null) return;

    final confirmed = await showTTGConfirmDialog(
      context: context,
      title: "Übung löschen",
      subtitle: "Wirklich löschen?",
    );

    if (confirmed) widget.onDelete!();
  }

  void _editValue(String title, int initial, Function(int) onSave) {
    final c = TextEditingController(text: "$initial");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B1F23),
        title: Text(title,
            style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () {
              final v = int.tryParse(c.text) ?? initial;
              setState(() => onSave(v));
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}