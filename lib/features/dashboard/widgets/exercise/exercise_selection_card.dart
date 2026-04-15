import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/body_regions.dart';
import '../../../../core/ui/ttg_value_picker_dialog.dart';
import '../../models/exercise.dart';
import '../../models/exercise_set.dart';
import '../../state/dashboard_provider.dart';
import 'exercise_select_sheet.dart';
import '../../../../core/ui/ttg_selection_category_sheet.dart';

class ExerciseSelectionCard extends ConsumerStatefulWidget {
  final String folderId;
  final String planId;
  final VoidCallback? onAdded;

  const ExerciseSelectionCard({
    super.key,
    required this.folderId,
    required this.planId,
    this.onAdded,
  });

  @override
  ConsumerState<ExerciseSelectionCard> createState() => _State();
}

class _State extends ConsumerState<ExerciseSelectionCard> {
  String? category;
  String? exercise;

  double weight = 0;
  int reps = 0;
  int sets = 0;

  IconData getCategoryIcon(String category) {
    return PhosphorIcons.barbell(PhosphorIconsStyle.fill);
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("KATEGORIE"),
          _picker(category, _pickCategory),
          _divider(),
          _label("ÜBUNG"),
          _picker(exercise, _pickExercise),
          _divider(),
          Row(
            children: [
              Expanded(
                child: _field(
                  "GEWICHT (KG)",
                  weight.toStringAsFixed(1),
                      () => _double(
                    "Gewicht",
                    weight,
                    500,
                        (v) => setState(() => weight = v),
                  ),
                ),
              ),
              Expanded(
                child: _field(
                  "WDH",
                  "$reps",
                      () => _int(
                    "Wiederholungen",
                    reps,
                    50,
                        (v) => setState(() => reps = v),
                  ),
                ),
              ),
              Expanded(
                child: _field(
                  "SÄTZE",
                  "$sets",
                      () => _int(
                    "Sätze",
                    sets,
                    20,
                        (v) => setState(() => sets = v),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _add,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
              ),
              child: const Text(
                "hinzufügen",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCategory() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: TTGSelectionSheet<String>(
          items: ["Alle Bereiche", ...categories],
          title: (c) => c,
          icon: (c) => getCategoryIcon(c),
          onSelect: (c) => Navigator.pop(context, c),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        category = result;
        exercise = null;
      });
    }
  }

  Future<void> _pickExercise() async {
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bitte zuerst Kategorie wählen")),
      );
      return;
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: ExerciseSelectSheet(category: category!),
      ),
    );

    if (result != null) {
      setState(() => exercise = result);
    }
  }

  void _add() {
    if (category == null || exercise == null) return;

    final safeSets = sets < 1 ? 1 : sets;

    final e = Exercise(
      id: DateTime.now().toString(),
      name: exercise!,
      bodyRegion: category!,
      sets: List.generate(
        safeSets,
            (_) => ExerciseSet(
          weight: weight,
          reps: reps,
        ),
      ),
    );

    ref.read(dashboardProvider.notifier).addExercise(
      widget.folderId,
      widget.planId,
      e,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Übung hinzugefügt")),
    );

    setState(() {
      category = null;
      exercise = null;
      weight = 0;
      reps = 0;
      sets = 0;
    });

    widget.onAdded?.call();
  }

  Widget _card({required Widget child}) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: child,
      ),
    ),
  );

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(color: Colors.white38, fontSize: 12),
  );

  Widget _picker(String? value, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Text(
      value ?? "Hier tippen",
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
  );

  Widget _divider() => const Divider(color: Colors.white12, height: 30);

  Widget _field(String title, String value, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      );

  void _int(String title, int current, int max, Function(int) onSave) {
    showTTGValuePicker(
      context: context,
      title: title,
      initial: current <= 0 ? 1 : current.toDouble(),
      allowDecimal: false,
      onSubmit: (v) {
        final value = v.toInt();
        setState(() => onSave(value));
      },
    );
  }

  void _double(
      String title,
      double current,
      double max,
      Function(double) onSave,
      ) {
    showTTGValuePicker(
      context: context,
      title: title,
      initial: current <= 0 ? 1 : current,
      allowDecimal: true,
      onSubmit: (v) {
        setState(() => onSave(v));
      },
    );
  }
}