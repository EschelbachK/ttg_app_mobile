import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../catalog/models/exercise_catalog_item.dart';
import '../../../../core/ui/ttg_exercise_selection_sheet.dart';
import '../../../../core/constants/body_regions.dart';
import '../../../catalog/state/exercise_catalog_state.dart';

class ExerciseSelectSheet extends ConsumerWidget {
  final String category;

  const ExerciseSelectSheet({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exerciseCatalogProvider);

    return exercisesAsync.when(
      data: (list) {
        final mappedBodyRegion = mapCategoryToBodyRegion(category);
        final filtered = mappedBodyRegion == "ALL"
            ? list
            : list.where((e) => e.bodyRegion.toUpperCase() == mappedBodyRegion.toUpperCase()).toList();

        return TTGExerciseSelectionSheet<ExerciseCatalogItem>(
          items: filtered,
          title: (e) => e.name,
          subtitle: (e) => e.equipment,
          onSelect: (e) => Navigator.pop(context, e.name),
        );
      },
      loading: () => const SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SizedBox(
        height: 500,
        child: Center(child: Text("Fehler: $e", style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}