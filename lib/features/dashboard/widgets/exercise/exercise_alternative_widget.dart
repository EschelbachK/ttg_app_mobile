import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/ranked_exercise_response.dart';
import '../../state/exercise_service_provider.dart';

final exerciseAlternativesProvider =
FutureProvider.family<List<RankedExerciseResponse>, String>((ref, exerciseId) async {
  final service = ref.read(exerciseServiceProvider);
  return service.getRankedAlternatives(exerciseId);
});

class ExerciseAlternativeWidget extends ConsumerWidget {
  final String exerciseId;

  const ExerciseAlternativeWidget({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(exerciseAlternativesProvider(exerciseId));

    return future.when(
      data: (alternatives) {
        if (alternatives.isEmpty) {
          return const Center(
            child: Text("Keine Alternativen verfügbar", style: TextStyle(color: Colors.white54)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alternatives.length,
          itemBuilder: (context, i) {
            final ranked = alternatives[i];
            final e = ranked.exercise;
            return ListTile(
              leading: e.imageUrl.isNotEmpty
                  ? Image.network(e.imageUrl, width: 40, height: 40, fit: BoxFit.cover)
                  : const Icon(Icons.fitness_center, color: Colors.white54),
              title: Text(e.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text("Rank: ${ranked.rank} • ${e.primaryMuscle}",
                  style: const TextStyle(color: Colors.white38)),
              onTap: () {},
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
      error: (e, _) => Center(child: Text("Fehler: $e", style: const TextStyle(color: Colors.red))),
    );
  }
}