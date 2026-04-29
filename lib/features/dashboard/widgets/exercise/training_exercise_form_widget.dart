import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../catalog/models/exercise_detail_model.dart';
import '../../../catalog/state/exercise_catalog_provider.dart';
import '../../../catalog/state/exercise_catalog_state.dart';
import '../../models/exercise.dart';
import '../../models/exercise_set.dart';
import '../../state/dashboard_provider.dart';
import '../../../../core/ui/ttg_value_picker_dialog.dart';
import '../../../../core/theme/app_theme.dart';

class TrainingExerciseFormWidget extends ConsumerStatefulWidget {
  final String folderId;
  final String planId;
  final Exercise? existingExercise;
  final VoidCallback? onSaved;

  const TrainingExerciseFormWidget({
    super.key,
    required this.folderId,
    required this.planId,
    this.existingExercise,
    this.onSaved,
  });

  @override
  ConsumerState<TrainingExerciseFormWidget> createState() => _TrainingExerciseFormWidgetState();
}

class _TrainingExerciseFormWidgetState extends ConsumerState<TrainingExerciseFormWidget> {
  String? category;
  String? exercise;
  double weight = 0;
  int reps = 0;
  int sets = 1;

  @override
  void initState() {
    super.initState();
    if (widget.existingExercise != null) {
      final e = widget.existingExercise!;
      category = e.bodyRegion;
      exercise = e.name;
      if (e.sets.isNotEmpty) {
        weight = e.sets.first.weight;
        reps = e.sets.first.reps;
        sets = e.sets.length;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(dashboardProvider.notifier);
    final exercises = ref.watch(exerciseCatalogProvider);

    return exercises.when(
      data: (list) {
        final categories = ["Alle Bereiche", ...list.map((e) => e.bodyRegion).toSet()];
        final filteredExercises =
        list.where((e) => category == null || category == "Alle Bereiche" || e.bodyRegion == category);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kategorie", style: TextStyle(color: Colors.white38)),
            DropdownButton<String>(
              value: category,
              dropdownColor: const Color(0xFF1B1F23),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: Colors.white))))
                  .toList(),
              onChanged: (v) => setState(() {
                category = v;
                exercise = null;
              }),
            ),
            const SizedBox(height: 10),
            const Text("Übung", style: TextStyle(color: Colors.white38)),
            DropdownButton<String>(
              value: exercise,
              dropdownColor: const Color(0xFF1B1F23),
              items: filteredExercises
                  .map((e) => DropdownMenuItem(value: e.name, child: Text(e.name, style: const TextStyle(color: Colors.white))))
                  .toList(),
              onChanged: (v) => setState(() => exercise = v),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _numberField("Gewicht (kg)", weight.toStringAsFixed(1), true, (v) => setState(() => weight = v)),
                const SizedBox(width: 10),
                _numberField("Wdh", reps.toString(), false, (v) => setState(() => reps = v.toInt())),
                const SizedBox(width: 10),
                _numberField("Sätze", sets.toString(), false, (v) => setState(() => sets = v.toInt())),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.existingExercise != null && widget.existingExercise is ExerciseDetailModel) ...[
              _buildExpandableList("Instructions", (widget.existingExercise as ExerciseDetailModel).instructions),
              _buildExpandableList("Tips", (widget.existingExercise as ExerciseDetailModel).tips),
              _buildExpandableList("Common Mistakes", (widget.existingExercise as ExerciseDetailModel).commonMistakes),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed),
                onPressed: () {
                  if (category == null || exercise == null) return;
                  final e = Exercise(
                    id: widget.existingExercise?.id ?? DateTime.now().toString(),
                    name: exercise!,
                    bodyRegion: category!,
                    sets: List.generate(sets, (_) => ExerciseSet(weight: weight, reps: reps)),
                  );
                  if (widget.existingExercise != null) {
                    notifier.updateExercise(widget.folderId, widget.planId, e);
                  } else {
                    notifier.addExercise(widget.folderId, widget.planId, e);
                  }
                  widget.onSaved?.call();
                },
                child: const Text("Speichern"),
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text("Fehler: $e", style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _numberField(String label, String value, bool decimal, Function(double) onChanged) {
    return Expanded(
      child: GestureDetector(
        onTap: () => showTTGValuePicker(
          context: context,
          title: label,
          initial: double.tryParse(value) ?? 0,
          allowDecimal: decimal,
          onSubmit: onChanged,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableList(String title, List<String> items) {
    return ExpansionTile(
      collapsedIconColor: Colors.white54,
      iconColor: Colors.white,
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      children: items
          .asMap()
          .entries
          .map((e) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text("${e.key + 1}. ${e.value}", style: const TextStyle(color: Colors.white70)),
      ))
          .toList(),
    );
  }
}