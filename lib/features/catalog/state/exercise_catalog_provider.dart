import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../api/catalog_api.dart';
import '../models/exercise_catalog_item.dart';
import '../../../core/constants/exercise_body_regions.dart';
import '../../../core/constants/exercise_types_constants.dart';
import '../../../core/constants/exercise_tags_constants.dart';

final catalogApiProvider = Provider<CatalogApi>((ref) => CatalogApi(ref.read(dioProvider)));

final exerciseCatalogStateProvider = StateNotifierProvider<ExerciseCatalogNotifier, ExerciseCatalogState>(
      (ref) => ExerciseCatalogNotifier(ref),
);

class ExerciseCatalogState {
  final List<ExerciseCatalogItem> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String bodyRegion;
  final String exerciseType;
  final List<String> tags;

  ExerciseCatalogState({
    required this.items,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.bodyRegion = BodyRegions.ALL,
    this.exerciseType = ExerciseTypes.ALL,
    this.tags = const [],
  });

  ExerciseCatalogState copyWith({
    List<ExerciseCatalogItem>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
    String? bodyRegion,
    String? exerciseType,
    List<String>? tags,
  }) =>
      ExerciseCatalogState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        hasMore: hasMore ?? this.hasMore,
        error: error ?? this.error,
        bodyRegion: bodyRegion ?? this.bodyRegion,
        exerciseType: exerciseType ?? this.exerciseType,
        tags: tags ?? this.tags,
      );
}

class ExerciseCatalogNotifier extends StateNotifier<ExerciseCatalogState> {
  final Ref ref;
  int _page = 0;
  static const _pageSize = 20;

  ExerciseCatalogNotifier(this.ref) : super(ExerciseCatalogState(items: []));

  Future<void> updateFilters({String? bodyRegion, String? exerciseType, List<String>? tags}) async {
    _page = 0;
    state = state.copyWith(
      items: [],
      isLoading: true,
      bodyRegion: bodyRegion ?? state.bodyRegion,
      exerciseType: exerciseType ?? state.exerciseType,
      tags: tags ?? state.tags,
    );
    await fetchExercises(refresh: true);
  }

  Future<void> fetchExercises({bool refresh = false}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final api = ref.read(catalogApiProvider);
      final filter = <String, dynamic>{};
      if (state.bodyRegion != BodyRegions.ALL) filter['bodyRegion'] = state.bodyRegion;
      if (state.exerciseType != ExerciseTypes.ALL) filter['exerciseType'] = state.exerciseType;
      if (state.tags.isNotEmpty) filter['tags'] = state.tags;
      final data = await api.fetchExercises(filter: filter.isEmpty ? null : filter, page: _page, size: _pageSize);
      final items = data.map((json) => ExerciseCatalogItem.fromJson(json)).toList();
      _page++;
      state = state.copyWith(items: refresh ? items : [...state.items, ...items], hasMore: items.length == _pageSize, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}