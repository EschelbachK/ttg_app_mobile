import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/catalog_api.dart';
import '../models/exercise_catalog_item.dart';

final catalogApiProvider = Provider((ref) => CatalogApi());

final exerciseCatalogProvider =
FutureProvider<List<ExerciseCatalogItem>>((ref) async {
  final data = await ref.read(catalogApiProvider).fetchExercises();
  return data.map((e) => ExerciseCatalogItem.fromJson(e)).toList();
});