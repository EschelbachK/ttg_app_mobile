import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/catalog_api.dart';
import '../models/exercise_catalog_item.dart';

final catalogApiProvider = Provider<CatalogApi>((ref) {
  return CatalogApi();
});

final exerciseCatalogProvider =
FutureProvider<List<ExerciseCatalogItem>>((ref) async {

  final api = ref.read(catalogApiProvider);

  final exercises = await api.fetchExercises();

  return exercises
      .map((e) => ExerciseCatalogItem.fromJson(e))
      .toList();
});