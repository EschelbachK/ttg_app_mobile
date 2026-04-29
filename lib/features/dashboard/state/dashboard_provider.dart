import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/exercise_service.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/error/global_error_handler.dart';
import '../../../core/offline/offline_queue.dart';
import '../../../core/offline/offline_action.dart';
import '../../../core/offline/offline_cache.dart';
import '../../../core/offline/cache_keys.dart';
import '../../../core/settings/settings_controller.dart';
import '../api/dashboard_api.dart';
import '../models/exercise.dart';
import '../models/training_folder.dart';
import '../models/training_plan.dart';
import 'exercise_service_provider.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(DashboardApi(ref.read(dioProvider)), ref),
);

class DashboardState {
  final List<TrainingPlan> trainingPlans, archivedPlans;
  final List<TrainingFolder> folders, archivedFolders;
  final bool showArchive, isLoading;
  final String? error;

  const DashboardState({
    required this.trainingPlans,
    required this.folders,
    required this.archivedFolders,
    required this.archivedPlans,
    required this.showArchive,
    required this.isLoading,
    this.error,
  });

  factory DashboardState.initial() => const DashboardState(
    trainingPlans: [],
    folders: [],
    archivedFolders: [],
    archivedPlans: [],
    showArchive: false,
    isLoading: false,
  );

  DashboardState copyWith({
    List<TrainingPlan>? trainingPlans,
    List<TrainingFolder>? folders,
    List<TrainingFolder>? archivedFolders,
    List<TrainingPlan>? archivedPlans,
    bool? showArchive,
    bool? isLoading,
    String? error,
  }) =>
      DashboardState(
        trainingPlans: trainingPlans ?? this.trainingPlans,
        folders: folders ?? this.folders,
        archivedFolders: archivedFolders ?? this.archivedFolders,
        archivedPlans: archivedPlans ?? this.archivedPlans,
        showArchive: showArchive ?? this.showArchive,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi api;
  final Ref ref;
  late final ExerciseService exerciseService;

  DashboardNotifier(this.api, this.ref) : super(DashboardState.initial()) {
    exerciseService = ref.read(exerciseServiceProvider);
  }

  bool get _offline => ref.read(settingsProvider).offlineMode;

  void showPlans() => state = state.copyWith(showArchive: false);
  void showArchive() => state = state.copyWith(showArchive: true);

  Future<void> _execute(Future<void> Function() fn) async {
    if (_offline) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await fn();
    } catch (e) {
      state = state.copyWith(error: GlobalErrorHandler.handle(e).message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _runOrQueue({
    required String type,
    required Map<String, dynamic> payload,
    required Future<void> Function() online,
  }) async {
    if (_offline) {
      await OfflineQueue.add(OfflineAction(type: type, payload: payload));
      return;
    }
    try {
      await online();
      await loadTrainingPlans();
    } catch (e) {
      if (e is DioException) {
        print("❌ STATUS: ${e.response?.statusCode}");
        print("❌ DATA: ${e.response?.data}");
        print("❌ PATH: ${e.requestOptions.path}");
        print("❌ METHOD: ${e.requestOptions.method}");
      }
      rethrow;
    }
  }

  Future<void> loadTrainingPlans() async {
    if (_offline) {
      final cached = await OfflineCache.load(CacheKeys.dashboard);
      if (cached != null) {
        state = state.copyWith(
          trainingPlans: (cached['plans'] ?? []).map((e) => TrainingPlan.fromJson(e)).toList(),
          archivedPlans: (cached['archivedPlans'] ?? []).map((e) => TrainingPlan.fromJson(e)).toList(),
          archivedFolders: (cached['archivedFolders'] ?? []).map((e) => TrainingFolder.fromJson(e)).toList(),
          folders: (cached['folders'] ?? []).map((e) => TrainingFolder.fromJson(e)).toList(),
        );
      }
      return;
    }

    await _execute(() async {
      final plans = (await api.getTrainingPlans()).map((e) => TrainingPlan.fromJson(e)).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      final archivedPlans = (await api.getArchivedPlans()).map((e) => TrainingPlan.fromJson(e)).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      final archivedFoldersRaw = (await api.getArchivedFolders()).map((e) => TrainingFolder.fromJson(e)).toList();

      final archivedFolders = await Future.wait(archivedFoldersRaw.map((f) async {
        List<Exercise> exercises = [];
        try {
          if (f.trainingPlanId != null) {
            exercises = (await api.getExercises(planId: f.trainingPlanId, folderId: f.id))
                .map((x) => Exercise.fromJson(x))
                .toList();
          }
        } catch (_) {}
        return f.copyWith(exercises: exercises);
      }));

      final foldersNested = await Future.wait(plans.map((p) async {
        final folderData = await api.getFolders(p.id);
        final activeFolderData = folderData.where((e) => !archivedFolders.any((a) => a.id == e['id']));
        return Future.wait(activeFolderData.map((e) async {
          final f = TrainingFolder.fromJson(e);
          final ex = (await api.getExercises(planId: p.id, folderId: f.id))
              .map((x) => Exercise.fromJson(x))
              .toList();
          return f.copyWith(trainingPlanId: p.id, exercises: ex);
        }));
      }));

      final allFolders = foldersNested.expand((e) => e).toList();

      state = state.copyWith(
        trainingPlans: plans,
        archivedPlans: archivedPlans,
        archivedFolders: archivedFolders,
        folders: allFolders,
      );

      await OfflineCache.save(CacheKeys.dashboard, {
        'plans': plans.map((e) => e.toJson()).toList(),
        'archivedPlans': archivedPlans.map((e) => e.toJson()).toList(),
        'archivedFolders': archivedFolders.map((e) => e.toJson()).toList(),
        'folders': allFolders.map((e) => e.toJson()).toList(),
      });
    });
  }

  Future<void> createTrainingPlan(String name) => _runOrQueue(
    type: 'create_plan',
    payload: {'name': name},
    online: () => api.createTrainingPlan(name),
  );

  Future<void> importPlan(TrainingPlan plan) => createTrainingPlan(plan.name);

  Future<void> renamePlan(String id, String name) => _runOrQueue(
    type: 'rename_plan',
    payload: {'id': id, 'name': name},
    online: () => api.updateTrainingPlan(id, name),
  );

  Future<void> deletePlan(String id) => _runOrQueue(
    type: 'delete_plan',
    payload: {'id': id},
    online: () => api.deleteTrainingPlan(id),
  );

  Future<void> archivePlan(String id) => _runOrQueue(
    type: 'archive_plan',
    payload: {'id': id},
    online: () => api.archiveTrainingPlan(id),
  );

  Future<void> restorePlan(String id) => _runOrQueue(
    type: 'restore_plan',
    payload: {'id': id},
    online: () => api.restoreTrainingPlan(id),
  );

  // move plan up/down
  Future<void> movePlanUp(String id) async => _movePlan(id, up: true);
  Future<void> movePlanDown(String id) async => _movePlan(id, up: false);

  Future<void> _movePlan(String id, {required bool up}) async {
    final list = [...state.trainingPlans]..sort((a, b) => a.order.compareTo(b.order));
    final i = list.indexWhere((e) => e.id == id);
    if ((up && i <= 0) || (!up && i >= list.length - 1)) return;
    final current = list[i];
    final target = list[up ? i - 1 : i + 1];
    state = state.copyWith(
      trainingPlans: list
          .map((p) => p.id == current.id
          ? p.copyWith(order: target.order)
          : p.id == target.id
          ? p.copyWith(order: current.order)
          : p)
          .toList(),
    );
    if (_offline) return;
    try {
      await api.updateTrainingPlanOrder(current.id, target.order);
      await api.updateTrainingPlanOrder(target.id, current.order);
      await loadTrainingPlans();
    } catch (_) {}
  }

  // move folder up/down
  Future<void> moveFolderUp(String id) async => _moveFolder(id, up: true);
  Future<void> moveFolderDown(String id) async => _moveFolder(id, up: false);

  Future<void> _moveFolder(String id, {required bool up}) async {
    final list = [...state.folders]..sort((a, b) => a.order.compareTo(b.order));
    final i = list.indexWhere((e) => e.id == id);
    if ((up && i <= 0) || (!up && i >= list.length - 1)) return;
    final current = list[i];
    final target = list[up ? i - 1 : i + 1];
    state = state.copyWith(
      folders: list
          .map((f) => f.id == current.id
          ? f.copyWith(order: target.order)
          : f.id == target.id
          ? f.copyWith(order: current.order)
          : f)
          .toList(),
    );
  }

  Future<void> addFolder(String planId, String name) => _runOrQueue(
    type: 'create_folder',
    payload: {'planId': planId, 'name': name},
    online: () => api.createFolder(
      trainingPlanId: planId,
      name: name,
      order: state.folders.where((f) => f.trainingPlanId == planId).length,
    ),
  );

  Future<void> renameFolder(String id, String name) async => _execute(() async {
    await api.updateFolder(folderId: id, name: name);
    state = state.copyWith(
      folders: state.folders.map((f) => f.id == id ? f.copyWith(name: name) : f).toList(),
    );
  });

  Future<void> deleteFolder(String id) => _runOrQueue(
    type: 'delete_folder',
    payload: {'id': id},
    online: () => api.deleteFolder(id),
  );

  Future<void> duplicateFolder(String id) => _runOrQueue(
    type: 'duplicate_folder',
    payload: {'id': id},
    online: () => api.duplicateFolder(id),
  );

  Future<void> archiveFolder(String id) => _runOrQueue(
    type: 'archive_folder',
    payload: {'id': id},
    online: () => api.archiveFolder(id),
  );

  Future<void> restoreFolder(String id) => _runOrQueue(
    type: 'restore_folder',
    payload: {'id': id},
    online: () => api.restoreFolder(id),
  );

  Future<void> importFolderToPlan(
      {required String folderId, required String targetPlanId, required String name}) =>
      _runOrQueue(
        type: 'import_folder',
        payload: {'folderId': folderId, 'targetPlanId': targetPlanId, 'name': name},
        online: () async {
          await api.createFolder(
            trainingPlanId: targetPlanId,
            name: name,
            order: state.folders.where((f) => f.trainingPlanId == targetPlanId).length,
          );
        },
      );

  Future<void> _createExercise(String folderId, String planId, Exercise exercise) =>
      _runOrQueue(
        type: 'create_exercise',
        payload: {'folderId': folderId, 'planId': planId, 'name': exercise.name},
        online: () => api.createExercise(
          planId: planId,
          folderId: folderId,
          name: exercise.name,
          bodyRegion: _mapBodyRegion(exercise.bodyRegion),
          sets: exercise.sets.map((s) => {'weight': s.weight, 'repetitions': s.reps}).toList(),
        ),
      );

  Future<void> importExercise(String folderId, String planId, Exercise exercise) async {
    final uiExercise = exercise.copyWith(sets: exercise.sets.map((s) => s.copyWith()).toList());
    state = state.copyWith(
      folders: state.folders
          .map((f) => f.id != folderId
          ? f
          : f.copyWith(exercises: [...f.exercises.map((e) => e.copyWith()), uiExercise]))
          .toList(),
    );
    await _createExercise(folderId, planId, exercise);
  }

  Future<void> addExercise(String folderId, String planId, Exercise exercise) async {
    final uiExercise = exercise.copyWith(sets: exercise.sets.map((s) => s.copyWith()).toList());
    state = state.copyWith(
      folders: state.folders
          .map((f) => f.id != folderId
          ? f
          : f.copyWith(exercises: [...f.exercises.map((e) => e.copyWith()), uiExercise]))
          .toList(),
    );
    await _createExercise(folderId, planId, exercise);
  }

  Future<void> updateExercise(String folderId, String planId, Exercise exercise) async {
    final uiExercise = exercise.copyWith(sets: exercise.sets.map((s) => s.copyWith()).toList());
    state = state.copyWith(
      folders: state.folders.map((f) {
        if (f.id != folderId) return f;
        return f.copyWith(
          exercises: f.exercises.map((e) => e.id == exercise.id ? uiExercise : e).toList(),
        );
      }).toList(),
    );
    await _createExercise(folderId, planId, exercise);
  }

  Future<void> removeExercise({required String planId, required String folderId, required String exerciseId}) =>
      _runOrQueue(
        type: 'delete_exercise',
        payload: {'planId': planId, 'folderId': folderId, 'exerciseId': exerciseId},
        online: () => api.deleteExercise(planId: planId, folderId: folderId, exerciseId: exerciseId),
      );

  Future<void> updateExerciseSets({required String planId, required String folderId, required String exerciseId}) async {
    try {
      final exercise =
      state.folders.firstWhere((f) => f.id == folderId).exercises.firstWhere((e) => e.id == exerciseId);
      await api.updateExercise(
        planId: planId,
        folderId: folderId,
        exerciseId: exerciseId,
        sets: exercise.sets.map((s) => {'weight': s.weight, 'repetitions': s.reps}).toList(),
      );
    } catch (e) {
      print("❌ updateExerciseSets failed: $e");
    }
  }

  String _mapBodyRegion(String c) {
    switch (c) {
      case "Brust":
        return "BRUST";
      case "Rücken":
        return "RUECKEN";
      case "Beine":
        return "BEINE";
      case "Schultern":
        return "SCHULTERN";
      case "Bizeps":
        return "BIZEPS";
      case "Trizeps":
        return "TRIZEPS";
      case "Bauch":
        return "BAUCH";
      case "Nacken":
        return "NACKEN";
      case "Unterarme":
        return "UNTERARME";
      case "Cardio":
        return "CARDIO";
      case "Ganzkörper":
        return "GANZKOERPER";
      default:
        return "GANZKOERPER";
    }
  }
}