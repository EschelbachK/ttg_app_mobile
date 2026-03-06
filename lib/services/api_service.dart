import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/dio_provider.dart';
import '../features/auth/models/auth_response.dart';
import '../features/catalog/models/exercise_catalog.dart';
import '../features/workout/models/training_exercise.dart';
import '../features/workout/models/training_folder.dart';
import '../features/workout/models/training_plan.dart';
import 'token_storage.dart';

class ApiService {
  final Ref ref;

  ApiService(this.ref);

  /// --------------------------------------------------
  /// AUTH
  /// --------------------------------------------------

  Future<AuthResponse> login(
      String email,
      String password,
      ) async {

    final dio = ref.read(dioProvider);
    final tokenStorage = ref.read(tokenStorageProvider);

    final response = await dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    final authResponse =
    AuthResponse.fromJson(response.data);

    await tokenStorage.saveTokens(
      authResponse.accessToken,
      authResponse.refreshToken,
    );

    return authResponse;
  }
// =============================
// TRAINING PLANS
// =============================

  Future<List<TrainingPlan>> getTrainingPlans() async {
    final dio = ref.read(dioProvider);

    final res = await dio.get("/training-plans");

    return (res.data as List)
        .map((e) => TrainingPlan.fromJson(e))
        .toList();
  }

  Future<void> createTrainingPlan(String title) async {
    final dio = ref.read(dioProvider);

    await dio.post(
      "/training-plans",
      data: {"title": title},
    );
  }

// =============================
// FOLDERS (Muskelgruppen)
// =============================

  Future<List<TrainingFolder>> getFolders(String planId) async {
    final dio = ref.read(dioProvider);

    final res =
    await dio.get("/training-plans/$planId/folders");

    return (res.data as List)
        .map((e) => TrainingFolder.fromJson(e))
        .toList();
  }

  Future<void> createFolder(
      String planId,
      String name,
      ) async {
    final dio = ref.read(dioProvider);

    await dio.post(
      "/training-plans/$planId/folders",
      data: {"name": name},
    );
  }

  Future<void> deleteFolder(
      String planId,
      String folderId,
      ) async {
    final dio = ref.read(dioProvider);

    await dio.delete(
      "/training-plans/$planId/folders/$folderId",
    );
  }

// =============================
// EXERCISES
// =============================

  Future<List<TrainingExercise>> getExercises(
      String folderId,
      ) async {
    final dio = ref.read(dioProvider);

    final res =
    await dio.get("/folders/$folderId/exercises");

    return (res.data as List)
        .map((e) => TrainingExercise.fromJson(e))
        .toList();
  }

  Future<void> createExercise(
      String folderId,
      String name,
      ) async {
    final dio = ref.read(dioProvider);

    await dio.post(
      "/folders/$folderId/exercises",
      data: {"name": name},
    );
  }

  Future<void> deleteExercise(
      String folderId,
      String exerciseId,
      ) async {
    final dio = ref.read(dioProvider);

    await dio.delete(
      "/folders/$folderId/exercises/$exerciseId",
    );
  }

  Future<void> addExerciseToFolder(
      String folderId,
      String catalogExerciseId,
      ) async {
    final dio = ref.read(dioProvider);

    await dio.post(
      "/folders/$folderId/exercises/from-catalog",
      data: {
        "catalogExerciseId": catalogExerciseId,
      },
    );
  }

// =============================
// CATALOG
// =============================

  Future<List<ExerciseCatalog>> getCatalogExercises(
      String bodyRegion,
      ) async {
    final dio = ref.read(dioProvider);

    final res = await dio.get(
      "/exercise-catalog",
      queryParameters: {"bodyRegion": bodyRegion},
    );

    return (res.data as List)
        .map((e) => ExerciseCatalog.fromJson(e))
        .toList();


  }}