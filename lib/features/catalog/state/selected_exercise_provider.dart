// lib/features/catalog/state/selected_exercise_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../api/catalog_api.dart';
import '../models/exercise_detail_model.dart';

final selectedExerciseApiProvider = Provider<CatalogApi>((ref) => CatalogApi(ref.read(dioProvider)));

final selectedExerciseProvider = FutureProvider.autoDispose
    .family<ExerciseDetailModel, String>((ref, exerciseId) async {
  final api = ref.read(selectedExerciseApiProvider);
  final data = await api.fetchExerciseDetail(exerciseId);
  return ExerciseDetailModel.fromJson(data);
});