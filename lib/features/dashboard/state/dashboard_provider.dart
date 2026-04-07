import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/error/global_error_handler.dart';
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
  }) =>
      DashboardState(
        trainingPlans: trainingPlans ?? this.trainingPlans,
        folders: folders ?? this.folders,
        archivedFolders: archivedFolders ?? this.archivedFolders,
        archivedPlans: archivedPlans ?? this.archivedPlans,
        showArchive: showArchive ?? this.showArchive,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi api;
  final Ref ref;

  DashboardNotifier(this.api, this.ref)
      : super(DashboardState.initial());

  void showPlans() => state = state.copyWith(showArchive: false);
  void showArchive() => state = state.copyWith(showArchive: true);

  Future<void> loadTrainingPlans() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final plans = (await api.getTrainingPlans())
          .map<TrainingPlan>((e) => TrainingPlan.fromJson(e))
          .toList();

      final archivedPlans = (await api.getArchivedPlans())
          .map<TrainingPlan>((e) => TrainingPlan.fromJson(e))
          .toList();

      final archivedFolders = (await api.getArchivedFolders())
          .map<TrainingFolder>((e) => TrainingFolder.fromJson(e))
          .toList();

      final allPlans = [...plans, ...archivedPlans];
      List<TrainingFolder> allFolders = [];

      for (final p in allPlans) {
        final folderData = await api.getFolders(p.id);
        final folders = await Future.wait(folderData.map((e) async {
          final f = TrainingFolder.fromJson(e);
          final ex = await api.getExercises(planId: p.id, folderId: f.id);
          return f.copyWith(
            trainingPlanId: p.id,
            exercises:
            ex.map<Exercise>((x) => Exercise.fromJson(x)).toList(),
          );
        }));

        allFolders.addAll(
            folders.where((f) => !archivedFolders.any((a) => a.id == f.id)));
      }

      state = state.copyWith(
        trainingPlans: plans,
        archivedPlans: archivedPlans,
        archivedFolders: archivedFolders,
        folders: allFolders,
        isLoading: false,
      );
    } catch (e) {
      final err = GlobalErrorHandler.handle(e);
      state = state.copyWith(isLoading: false, error: err.message);
    }
  }

  Future<void> createTrainingPlan(String name) async {
    await api.createTrainingPlan(name);
    await loadTrainingPlans();
  }

  Future<void> importPlan(TrainingPlan plan) async {
    await api.createTrainingPlan(plan.name);
    await loadTrainingPlans();
  }

  Future<void> renamePlan(String id, String name) async {
    await api.updateTrainingPlan(id, name);
    await loadTrainingPlans();
  }

  Future<void> deletePlan(String id) async {
    await api.deleteTrainingPlan(id);
    await loadTrainingPlans();
  }

  Future<void> archivePlan(String id) async {
    await api.archiveTrainingPlan(id);
    await loadTrainingPlans();
  }

  Future<void> restorePlan(String id) async {
    await api.restoreTrainingPlan(id);
    await loadTrainingPlans();
  }

  Future<void> addFolder(String planId, String name) async {
    await api.createFolder(
      trainingPlanId: planId,
      name: name,
      order:
      state.folders.where((f) => f.trainingPlanId == planId).length,
    );
    await loadTrainingPlans();
  }

  Future<void> renameFolder(String id, String name) async {
    await api.updateFolder(folderId: id, name: name);
    state = state.copyWith(
      folders: state.folders
          .map((f) => f.id == id ? f.copyWith(name: name) : f)
          .toList(),
    );
  }

  Future<void> deleteFolder(String id) async {
    await api.deleteFolder(id);
    await loadTrainingPlans();
  }

  Future<void> duplicateFolder(String id) async {
    await api.duplicateFolder(id);
    await loadTrainingPlans();
  }

  Future<void> archiveFolder(String id) async {
    await api.archiveFolder(id);
    await loadTrainingPlans();
  }

  Future<void> restoreFolder(String id) async {
    await api.restoreFolder(id);
    await loadTrainingPlans();
  }

  Future<void> moveFolderUp(String id) async {
    final f = state.folders.firstWhere((e) => e.id == id);
    final list = state.folders
        .where((e) => e.trainingPlanId == f.trainingPlanId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final i = list.indexWhere((e) => e.id == id);
    if (i <= 0) return;

    await api.updateFolderOrder(id, list[i - 1].order);
    await loadTrainingPlans();
  }

  Future<void> moveFolderDown(String id) async {
    final f = state.folders.firstWhere((e) => e.id == id);
    final list = state.folders
        .where((e) => e.trainingPlanId == f.trainingPlanId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final i = list.indexWhere((e) => e.id == id);
    if (i >= list.length - 1) return;

    await api.updateFolderOrder(id, list[i + 1].order);
    await loadTrainingPlans();
  }

  Future<void> importFolderToPlan({
    required String folderId,
    required String targetPlanId,
    required String name,
  }) async {
    await api.createFolder(
      trainingPlanId: targetPlanId,
      name: name,
      order: state.folders
          .where((f) => f.trainingPlanId == targetPlanId)
          .length,
    );
    await api.restoreFolder(folderId);
    await loadTrainingPlans();


  }Future<void> importExercise(

      String folderId,
      String planId,
      Exercise exercise,
      ) async {
    await api.createExercise(
      planId: planId,
      folderId: folderId,
      name: exercise.name,
    );

    await loadTrainingPlans();
  }
  Future<void> addExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) async {
    await api.createExercise(
      planId: planId,
      folderId: folderId,
      name: exercise.name,
    );

    await loadTrainingPlans();
  }

}