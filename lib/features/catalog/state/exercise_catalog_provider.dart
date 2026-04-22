import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../api/catalog_api.dart';
import '../models/exercise_catalog_item.dart';

final catalogApiProvider = Provider(
      (ref) => CatalogApi(ref.read(dioProvider)),
);

final exerciseCatalogProvider =
FutureProvider<List<ExerciseCatalogItem>>((ref) async {
  final data =
  await ref.read(catalogApiProvider).fetchExercises();

  return data
      .map((e) => ExerciseCatalogItem.fromJson(e))
      .toList()
    ..sort((a, b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase()));
});