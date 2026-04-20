import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/error/global_error_handler.dart';
import '../../settings/application/settings_provider.dart';
import '../api/dashboard_api.dart';
import '../models/exercise.dart';
import '../models/training_folder.dart';
import '../models/training_plan.dart';

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(DashboardApi(ref.read(dioProvider)), ref);
});

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
  }) {
    return DashboardState(
      trainingPlans: trainingPlans ?? this.trainingPlans,
      folders: folders ?? this.folders,
      archivedFolders: archivedFolders ?? this.archivedFolders,
      archivedPlans: archivedPlans ?? this.archivedPlans,
      showArchive: showArchive ?? this.showArchive,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi api;
  final Ref ref;

  DashboardNotifier(this.api, this.ref)
      : super(DashboardState.initial());

  void showPlans() => state = state.copyWith(showArchive: false);
  void showArchive() => state = state.copyWith(showArchive: true);

  Future<void> _execute(Future<void> Function() fn) async {
    if (ref.read(settingsProvider).offlineMode) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await fn();
    } catch (e) {
      final err = GlobalErrorHandler.handle(e);
      state = state.copyWith(error: err.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadTrainingPlans() async => _execute(() async {
    final plans = (await api.getTrainingPlans())
        .map<TrainingPlan>((e) => TrainingPlan.fromJson(e))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final archivedPlans = (await api.getArchivedPlans())
        .map<TrainingPlan>((e) => TrainingPlan.fromJson(e))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final archivedFolders = (await api.getArchivedFolders())
        .map<TrainingFolder>((e) => TrainingFolder.fromJson(e))
        .toList();

    final foldersNested = await Future.wait(
      [...plans, ...archivedPlans].map((p) async {
        final folderData = await api.getFolders(p.id);

        return Future.wait(folderData.map((e) async {
          final f = TrainingFolder.fromJson(e);
          final ex = await api.getExercises(
            planId: p.id,
            folderId: f.id,
          );

          return f.copyWith(
            trainingPlanId: p.id,
            exercises:
            ex.map<Exercise>((x) => Exercise.fromJson(x)).toList(),
          );
        }));
      }),
    );

    final allFolders = foldersNested
        .expand((e) => e)
        .where((f) => !archivedFolders.any((a) => a.id == f.id))
        .toList();

    state = state.copyWith(
      trainingPlans: plans,
      archivedPlans: archivedPlans,
      archivedFolders: archivedFolders,
      folders: allFolders,
    );
  });

  Future<void> _refresh(Future<void> Function() fn) async {
    if (ref.read(settingsProvider).offlineMode) return;
    await fn();
    await loadTrainingPlans();
  }

  Future<void> createTrainingPlan(String name) async =>
      _refresh(() => api.createTrainingPlan(name));

  Future<void> importPlan(TrainingPlan plan) async =>
      _refresh(() => api.createTrainingPlan(plan.name));

  Future<void> renamePlan(String id, String name) async =>
      _refresh(() => api.updateTrainingPlan(id, name));

  Future<void> deletePlan(String id) async =>
      _refresh(() => api.deleteTrainingPlan(id));

  Future<void> archivePlan(String id) async =>
      _refresh(() => api.archiveTrainingPlan(id));

  Future<void> restorePlan(String id) async =>
      _refresh(() => api.restoreTrainingPlan(id));

  Future<void> movePlanUp(String id) async {
    final list = [...state.trainingPlans]
      ..sort((a, b) => a.order.compareTo(b.order));

    final i = list.indexWhere((e) => e.id == id);
    if (i <= 0) return;

    final current = list[i];
    final target = list[i - 1];

    state = state.copyWith(
      trainingPlans: list.map((p) {
        if (p.id == current.id) return p.copyWith(order: target.order);
        if (p.id == target.id) return p.copyWith(order: current.order);
        return p;
      }).toList(),
    );

    if (ref.read(settingsProvider).offlineMode) return;

    try {
      await api.updateTrainingPlanOrder(current.id, target.order);
      await api.updateTrainingPlanOrder(target.id, current.order);
      await loadTrainingPlans();
    } catch (_) {}
  }

  Future<void> movePlanDown(String id) async {
    final list = [...state.trainingPlans]
      ..sort((a, b) => a.order.compareTo(b.order));

    final i = list.indexWhere((e) => e.id == id);
    if (i >= list.length - 1) return;

    final current = list[i];
    final target = list[i + 1];

    state = state.copyWith(
      trainingPlans: list.map((p) {
        if (p.id == current.id) return p.copyWith(order: target.order);
        if (p.id == target.id) return p.copyWith(order: current.order);
        return p;
      }).toList(),
    );

    if (ref.read(settingsProvider).offlineMode) return;

    try {
      await api.updateTrainingPlanOrder(current.id, target.order);
      await api.updateTrainingPlanOrder(target.id, current.order);
      await loadTrainingPlans();
    } catch (_) {}
  }

  Future<void> moveFolderUp(String id) async {
    final list = [...state.folders]
      ..sort((a, b) => a.order.compareTo(b.order));

    final i = list.indexWhere((e) => e.id == id);
    if (i <= 0) return;

    final current = list[i];
    final target = list[i - 1];

    state = state.copyWith(
      folders: list.map((f) {
        if (f.id == current.id) return f.copyWith(order: target.order);
        if (f.id == target.id) return f.copyWith(order: current.order);
        return f;
      }).toList(),
    );
  }

  Future<void> moveFolderDown(String id) async {
    final list = [...state.folders]
      ..sort((a, b) => a.order.compareTo(b.order));

    final i = list.indexWhere((e) => e.id == id);
    if (i >= list.length - 1) return;

    final current = list[i];
    final target = list[i + 1];

    state = state.copyWith(
      folders: list.map((f) {
        if (f.id == current.id) return f.copyWith(order: target.order);
        if (f.id == target.id) return f.copyWith(order: current.order);
        return f;
      }).toList(),
    );
  }

  Future<void> addFolder(String planId, String name) async =>
      _refresh(() => api.createFolder(
        trainingPlanId: planId,
        name: name,
        order: state.folders
            .where((f) => f.trainingPlanId == planId)
            .length,
      ));

  Future<void> renameFolder(String id, String name) async =>
      _execute(() async {
        await api.updateFolder(folderId: id, name: name);
        state = state.copyWith(
          folders: state.folders
              .map((f) => f.id == id ? f.copyWith(name: name) : f)
              .toList(),
        );
      });

  Future<void> deleteFolder(String id) async =>
      _refresh(() => api.deleteFolder(id));

  Future<void> duplicateFolder(String id) async =>
      _refresh(() => api.duplicateFolder(id));

  Future<void> archiveFolder(String id) async =>
      _refresh(() => api.archiveFolder(id));

  Future<void> restoreFolder(String id) async =>
      _refresh(() => api.restoreFolder(id));

  Future<void> importFolderToPlan({
    required String folderId,
    required String targetPlanId,
    required String name,
  }) async =>
      _refresh(() async {
        await api.createFolder(
          trainingPlanId: targetPlanId,
          name: name,
          order: state.folders
              .where((f) => f.trainingPlanId == targetPlanId)
              .length,
        );
        await api.restoreFolder(folderId);
      });

  Future<void> _createExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) async =>
      _refresh(() => api.createExercise(
        planId: planId,
        folderId: folderId,
        name: exercise.name,
        bodyRegion: _mapBodyRegion(exercise.bodyRegion),
        sets: exercise.sets
            .map((s) => {
          'weight': s.weight,
          'repetitions': s.reps,
        })
            .toList(),
      ));

  Future<void> addExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) async {
    state = state.copyWith(
      folders: state.folders.map((f) {
        if (f.id != folderId) return f;
        return f.copyWith(exercises: [...f.exercises, exercise]);
      }).toList(),
    );

    await _createExercise(folderId, planId, exercise);
    await loadTrainingPlans();
  }

  Future<void> importExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) async =>
      _createExercise(folderId, planId, exercise);

  Future<void> removeExercise({
    required String planId,
    required String folderId,
    required String exerciseId,
  }) async =>
      _refresh(() => api.deleteExercise(
        planId: planId,
        folderId: folderId,
        exerciseId: exerciseId,
      ));

  String _mapBodyRegion(String category) {
    switch (category) {
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