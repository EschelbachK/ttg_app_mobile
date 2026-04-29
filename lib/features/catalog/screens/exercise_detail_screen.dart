import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/widgets/exercise/exercise_alternative_widget.dart';
import '../../dashboard/widgets/exercise/exercise_media_widget.dart';
import '../../dashboard/widgets/exercise/training_exercise_form_widget.dart';
import '../state/selected_exercise_provider.dart';
import '../models/exercise_detail_model.dart';
import '../../dashboard/models/exercise.dart';
import '../../dashboard/models/exercise_set.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;
  final String folderId;
  final String planId;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(selectedExerciseProvider(exerciseId));

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,
        title: const Text('Übungsdetails', style: TextStyle(color: Colors.white)),
      ),
      body: exerciseAsync.when(
        data: (exercise) => _buildDetail(context, exercise),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Exercise _mapDetailToExercise(ExerciseDetailModel detail) => Exercise(
    id: detail.id,
    name: detail.name,
    bodyRegion: detail.bodyRegion,
    sets: [const ExerciseSet(weight: 0, reps: 0)],
  );

  Widget _buildDetail(BuildContext context, ExerciseDetailModel exercise) {
    final mappedExercise = _mapDetailToExercise(exercise);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exercise.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Muskelgruppe: ${exercise.bodyRegion}', style: const TextStyle(color: Colors.white70)),
          Text('Equipment: ${exercise.equipment}', style: const TextStyle(color: Colors.white70)),
          Text('Schwierigkeit: ${exercise.difficulty}', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          ExerciseMediaWidget(media: exercise.media),
          const SizedBox(height: 16),
          if (exercise.id.isNotEmpty) ...[
            Text('Alternativen', style: Theme.of(context).textTheme.titleMedium),
            ExerciseAlternativeWidget(exerciseId: exercise.id),
            const SizedBox(height: 16),
          ],
          _buildExpandableLists(exercise),
          const SizedBox(height: 16),
          Text('Übung bearbeiten / hinzufügen', style: Theme.of(context).textTheme.titleMedium),
          TrainingExerciseFormWidget(
            folderId: folderId,
            planId: planId,
            existingExercise: mappedExercise,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableLists(ExerciseDetailModel exercise) {
    Widget buildExpandable(String title, List<String> items) => items.isEmpty
        ? const SizedBox()
        : ExpansionTile(
      collapsedIconColor: Colors.white54,
      iconColor: Colors.white,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      children: items
          .asMap()
          .entries
          .map((e) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text("${e.key + 1}. ${e.value}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ))
          .toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildExpandable("Anleitung", exercise.instructions),
        buildExpandable("Tipps", exercise.tips),
        buildExpandable("Häufige Fehler", exercise.commonMistakes),
      ],
    );
  }
}