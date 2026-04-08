import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/exercise_set.dart';
import '../../state/dashboard_provider.dart';
import 'exercise_select_sheet.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise.dart';

class ExerciseSelectionCard extends ConsumerStatefulWidget {
  final String folderId;
  final String planId;

  const ExerciseSelectionCard({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  ConsumerState<ExerciseSelectionCard> createState() =>
      _ExerciseSelectionCardState();
}

class _ExerciseSelectionCardState extends ConsumerState<ExerciseSelectionCard> {
  String? selectedCategory;
  String? selectedExercise;

  double weight = 0;
  int reps = 0;
  int sets = 0;

  final List<String> categories = [
    "Brustmuskulatur",
    "Rücken",
    "Beine",
    "Schultern",
    "Bizeps",
    "Trizeps",
    "Bauchmuskulatur",
    "Nacken",
    "Unterarme",
    "Cardio",
    "Ganzkörpertraining",
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("KATEGORIE", style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _selectCategory(context),
                child: Text(selectedCategory ?? "Hier tippen", style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const Divider(color: Colors.white12, height: 30),
              const Text("ÜBUNG", style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _selectExercise(context),
                child: Text(selectedExercise ?? "Hier tippen", style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const Divider(color: Colors.white12, height: 30),
              Row(
                children: [
                  Expanded(child: buildField("GEWICHT (KG)", weight.toStringAsFixed(1), () => openWeightPicker())),
                  Expanded(child: buildField("WIEDERHOLUNGEN", reps.toString(), () => openIntPicker("Wiederholungen", reps, 50, (v) => setState(() => reps = v)))),
                  Expanded(child: buildField("SÄTZE", sets.toString(), () => openIntPicker("Sätze", sets, 20, (v) => setState(() => sets = v)))),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed),
                  onPressed: () => _addExercise(),
                  child: const Text("hinzufügen", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addExercise() {
    if (selectedExercise == null || selectedCategory == null) return;

    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: selectedExercise!,
      sets: List.generate(
        sets,
            (index) => ExerciseSet(weight: weight, reps: reps),
      ),
    );

    ref.read(dashboardProvider.notifier).addExercise(widget.folderId, widget.planId, exercise);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Übung erfolgreich hinzugefügt")),
    );

    setState(() {
      selectedCategory = null;
      selectedExercise = null;
      weight = 0;
      reps = 0;
      sets = 0;
    });
  }

  Widget buildField(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }

  void openIntPicker(String title, int current, int max, Function(int) onSelected) {
    int selected = current;
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: const Color(0xFF1B1F23),
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(16), child: Text(title, style: const TextStyle(color: Colors.white))),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(initialItem: current),
                onSelectedItemChanged: (index) => selected = index,
                children: List.generate(max, (i) => Center(child: Text("$i", style: const TextStyle(color: Colors.white)))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Abbrechen", style: TextStyle(color: Colors.white70))),
                TextButton(
                  onPressed: () {
                    onSelected(selected);
                    Navigator.pop(context);
                  },
                  child: const Text("OK", style: TextStyle(color: AppTheme.primaryRed)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void openWeightPicker() {
    int kg = weight.floor();
    int decimal = (weight * 10).toInt() % 10;
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: const Color(0xFF1B1F23),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(16), child: Text("Gewicht", style: TextStyle(color: Colors.white))),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(initialItem: kg),
                      onSelectedItemChanged: (v) => kg = v,
                      children: List.generate(300, (i) => Center(child: Text("$i", style: const TextStyle(color: Colors.white)))),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(initialItem: decimal),
                      onSelectedItemChanged: (v) => decimal = v,
                      children: List.generate(10, (i) => Center(child: Text(".$i", style: const TextStyle(color: Colors.white)))),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Abbrechen", style: TextStyle(color: Colors.white70))),
                TextButton(
                  onPressed: () {
                    setState(() => weight = kg + decimal / 10);
                    Navigator.pop(context);
                  },
                  child: const Text("OK", style: TextStyle(color: AppTheme.primaryRed)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _selectCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1F23),
      builder: (_) => ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white38),
            onTap: () {
              setState(() {
                selectedCategory = category;
                selectedExercise = null;
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _selectExercise(BuildContext context) async {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bitte zuerst eine Kategorie auswählen")));
      return;
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseSelectSheet(category: selectedCategory!),
    );

    if (result != null) {
      setState(() => selectedExercise = result);
    }
  }
}