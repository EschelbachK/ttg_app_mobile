import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_folder.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/error/global_error_handler.dart';
import '../api/dashboard_api.dart';

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final dio = ref.read(dioProvider);
  return DashboardNotifier(DashboardApi(dio), ref);
});

class DashboardState {
  final List<TrainingPlan> trainingPlans;
  final List<TrainingFolder> folders;
  final List<TrainingFolder> archivedFolders;
  final List<TrainingPlan> archivedPlans;
  final bool showArchive;
  final bool isLoading;
  final String? error;

  DashboardState({
    required this.trainingPlans,
    required this.folders,
    required this.archivedFolders,
    required this.archivedPlans,
    required this.showArchive,
    required this.isLoading,
    this.error,
  });

  factory DashboardState.initial() {
    return DashboardState(
      trainingPlans: [],
      folders: [],
      archivedFolders: [],
      archivedPlans: [],
      showArchive: false,
      isLoading: false,
    );
  }

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
      error: error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi api;
  final Ref ref;

  DashboardNotifier(this.api, this.ref)
      : super(DashboardState.initial());

  void showPlans() {
    state = state.copyWith(showArchive: false);
  }

  void showArchive() {
    state = state.copyWith(showArchive: true);
  }

  Future<void> loadTrainingPlans() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final plansData = await api.getTrainingPlans();
      final archivedPlansData = await api.getArchivedPlans();
      final archivedFoldersData = await api.getArchivedFolders();

      final plans =
      plansData.map<TrainingPlan>((e) => TrainingPlan.fromJson(e)).toList();

      final archivedPlans = archivedPlansData
          .map<TrainingPlan>((e) => TrainingPlan.fromJson(e))
          .toList();

      final archivedFolders = archivedFoldersData
          .map<TrainingFolder>((e) => TrainingFolder.fromJson(e))
          .toList();

      List<TrainingFolder> allFolders = [];

      for (final plan in plans) {
        final folderData = await api.getFolders(plan.id);

        final folders = await Future.wait(
          folderData.map<Future<TrainingFolder>>((e) async {
            final folder = TrainingFolder.fromJson(e);

            final exercisesData = await api.getExercises(
              planId: plan.id,
              folderId: folder.id,
            );

            final exercises = exercisesData
                .map<Exercise>((ex) => Exercise.fromJson(ex))
                .toList();

            return folder.copyWith(
              trainingPlanId: plan.id,
              exercises: exercises,
            );
          }),
        );

        allFolders.addAll(folders);
      }

      for (final plan in archivedPlans) {
        final folderData = await api.getFolders(plan.id);

        final folders = await Future.wait(
          folderData.map<Future<TrainingFolder>>((e) async {
            final folder = TrainingFolder.fromJson(e);

            final exercisesData = await api.getExercises(
              planId: plan.id,
              folderId: folder.id,
            );

            final exercises = exercisesData
                .map<Exercise>((ex) => Exercise.fromJson(ex))
                .toList();

            return folder.copyWith(
              trainingPlanId: plan.id,
              exercises: exercises,
            );
          }),
        );

        allFolders.addAll(folders);
      }

      state = state.copyWith(
        trainingPlans: plans,
        archivedPlans: archivedPlans,
        archivedFolders: archivedFolders,
        folders: allFolders,
        isLoading: false,
      );
    } catch (e) {
      final error = GlobalErrorHandler.handle(e);
      state = state.copyWith(
        isLoading: false,
        error: error.message,
      );
    }
  }

  Future<void> createTrainingPlan(String name) async {
    try {
      await api.createTrainingPlan(name);
      await loadTrainingPlans();
    } catch (e) {
      final error = GlobalErrorHandler.handle(e);
      state = state.copyWith(error: error.message);
    }
  }

  Future<void> renamePlan(String planId, String name) async {
    await api.updateTrainingPlan(planId, name);
    await loadTrainingPlans(); // 🔥 ergänzt
  }

  Future<void> deletePlan(String planId) async {
    await api.deleteTrainingPlan(planId);
    await loadTrainingPlans(); // 🔥 FIX
  }

  Future<void> archivePlan(String planId) async {
    await api.archiveTrainingPlan(planId);
    await loadTrainingPlans(); // 🔥 FIX
  }

  Future<void> addFolder(String planId, String name) async {
    final count = state.folders
        .where((f) => f.trainingPlanId == planId)
        .length;

    await api.createFolder(
      trainingPlanId: planId,
      name: name,
      order: count,
    );

    await loadTrainingPlans();
  }

  Future<void> renameFolder(String folderId, String name) async {
    await api.updateFolder(folderId: folderId, name: name);
    await loadTrainingPlans(); // 🔥 ergänzt
  }

  Future<void> deleteFolder(String folderId) async {
    await api.deleteFolder(folderId);
    await loadTrainingPlans(); // 🔥 FIX
  }

  Future<void> duplicateFolder(String folderId) async {
    await api.duplicateFolder(folderId);
    await loadTrainingPlans(); // 🔥 ergänzt
  }

  Future<void> archiveFolder(String folderId) async {
    await api.archiveFolder(folderId);
    await loadTrainingPlans(); // 🔥 FIX
  }

  Future<void> restoreFolder(String folderId) async {
    await api.restoreFolder(folderId);
    await loadTrainingPlans(); // 🔥 ergänzt
  }

  Future<void> moveFolderUp(String folderId) async {
    final index = state.folders.indexWhere((f) => f.id == folderId);
    if (index <= 0) return;

    await api.updateFolderOrder(folderId, index - 1);
    await loadTrainingPlans(); // 🔥 sinnvoll
  }

  Future<void> moveFolderDown(String folderId) async {
    final index = state.folders.indexWhere((f) => f.id == folderId);
    if (index == -1) return;

    await api.updateFolderOrder(folderId, index + 1);
    await loadTrainingPlans(); // 🔥 sinnvoll
  }

  Future<void> importFolder(TrainingFolder folder) async {
    await api.createFolder(
      trainingPlanId: folder.trainingPlanId,
      name: folder.name,
      order: state.folders
          .where((f) => f.trainingPlanId == folder.trainingPlanId)
          .length,
    );
    await loadTrainingPlans(); // 🔥 ergänzt
  }

  Future<void> importPlan(TrainingPlan plan) async {
    await api.createTrainingPlan(plan.name);
    await loadTrainingPlans(); // 🔥 ergänzt
  }

  Future<void> importExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) async {}

  Future<void> addExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) async {}
}