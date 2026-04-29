import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/exercise_body_regions.dart';
import '../../../core/constants/exercise_types_constants.dart';
import '../../../core/constants/exercise_tags_constants.dart';
import '../state/exercise_catalog_provider.dart';

class ExerciseCatalogScreen extends ConsumerStatefulWidget {
  final String category;
  final String folderId;
  final String planId;

  const ExerciseCatalogScreen({
    super.key,
    required this.category,
    required this.folderId,
    required this.planId,
  });

  @override
  ConsumerState<ExerciseCatalogScreen> createState() => _ExerciseCatalogScreenState();
}

class _ExerciseCatalogScreenState extends ConsumerState<ExerciseCatalogScreen> {
  final _scrollController = ScrollController();
  String get mappedCategory => mapCategoryToBodyRegion(widget.category);
  String _selectedType = ExerciseTypes.ALL;
  final List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitial();
  }

  void _fetchInitial() {
    ref.read(exerciseCatalogStateProvider.notifier)
        .updateFilters(bodyRegion: mappedCategory, exerciseType: _selectedType, tags: _selectedTags);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(exerciseCatalogStateProvider.notifier).fetchExercises();
    }
  }

  void _onTypeChanged(String? type) {
    if (type == null) return;
    setState(() => _selectedType = type);
    ref.read(exerciseCatalogStateProvider.notifier)
        .updateFilters(bodyRegion: mappedCategory, exerciseType: _selectedType, tags: _selectedTags);
  }

  void _onTagsChanged(List<String> tags) {
    setState(() => _selectedTags
      ..clear()
      ..addAll(tags));
    ref.read(exerciseCatalogStateProvider.notifier)
        .updateFilters(bodyRegion: mappedCategory, exerciseType: _selectedType, tags: _selectedTags);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseCatalogStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,
        title: Text(widget.category, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: state.isLoading && state.items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.items.isEmpty
                ? Center(child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.white)))
                : RefreshIndicator(
              onRefresh: () async => ref.read(exerciseCatalogStateProvider.notifier)
                  .fetchExercises(refresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasMore ? state.items.length + 1 : state.items.length,
                itemBuilder: (_, i) {
                  if (i >= state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final e = state.items[i];
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: _selectedType,
            dropdownColor: const Color(0xFF1B1F23),
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            items: ExerciseTypes.all
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: _onTypeChanged,
          ),
          Wrap(
            spacing: 8,
            children: ExerciseTags.all.map((tag) {
              final selected = _selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag, style: TextStyle(color: selected ? Colors.white : Colors.white54)),
                selected: selected,
                selectedColor: const Color(0xFF3B3F43),
                backgroundColor: const Color(0xFF1B1F23),
                onSelected: (s) {
                  final newTags = List<String>.from(_selectedTags);
                  if (s) newTags.add(tag); else newTags.remove(tag);
                  _onTagsChanged(newTags);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}