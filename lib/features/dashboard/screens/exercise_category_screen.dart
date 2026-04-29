import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/state/exercise_catalog_state.dart';
import '../../../core/constants/body_regions.dart';

class ExerciseCategoryScreen extends ConsumerStatefulWidget {
  final String category;
  final String folderId;
  final String planId;

  const ExerciseCategoryScreen({
    super.key,
    required this.category,
    required this.folderId,
    required this.planId,
  });

  @override
  ConsumerState<ExerciseCategoryScreen> createState() => _ExerciseCategoryScreenState();
}

class _ExerciseCategoryScreenState extends ConsumerState<ExerciseCategoryScreen> {
  String get mappedCategory => mapCategoryToBodyRegion(widget.category);

  @override
  void initState() {
    super.initState();
    _fetchInitial();
  }

  void _fetchInitial() {
    ref.read(exerciseCatalogStateProvider.notifier)
        .updateFilters(bodyRegion: mappedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseCatalogStateProvider);
    final list = state.items.where((e) => e.bodyRegion == mappedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,
        title: Text(widget.category, style: const TextStyle(color: Colors.white)),
      ),
      body: state.isLoading && list.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && list.isEmpty
          ? Center(child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.white)))
          : list.isEmpty
          ? const Center(child: Text("Keine Übungen gefunden", style: TextStyle(color: Colors.white54)))
          : ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final e = list[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1F23),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(e.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text("${e.primaryMuscle} • ${e.equipment}",
                  style: const TextStyle(color: Colors.white54)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white38),
            ),
          );
        },
      ),
    );
  }
}