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
  return DashboardNotifier(DashboardApi(dio));
});

class DashboardState {
  final List<TrainingFolder> folders;
  final List<TrainingFolder> archivedFolders;
  final List<TrainingPlan> archivedPlans;
  final bool showArchive;
  final bool isLoading;
  final String? error;

  DashboardState({
    required this.folders,
    required this.archivedFolders,
    required this.archivedPlans,
    required this.showArchive,
    required this.isLoading,
    this.error,
  });

  factory DashboardState.initial() {
    return DashboardState(
      folders: [],
      archivedFolders: [],
      archivedPlans: [],
      showArchive: false,
      isLoading: false,
      error: null,
    );
  }

  DashboardState copyWith({
    List<TrainingFolder>? folders,
    List<TrainingFolder>? archivedFolders,
    List<TrainingPlan>? archivedPlans,
    bool? showArchive,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
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

  DashboardNotifier(this.api) : super(DashboardState.initial());

  void reset() {
    state = DashboardState.initial();
  }

  Future<void> loadFolders(String planId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await api.getFolders(planId);
      final folders =
      data.map<TrainingFolder>((e) => TrainingFolder.fromJson(e)).toList();

      state = state.copyWith(
        folders: folders,
        isLoading: false,
      );
    } catch (e) {
      final error = GlobalErrorHandler.handle(e);
      state = state.copyWith(isLoading: false, error: error.message);
    }
  }

  void showPlans() {
    state = state.copyWith(showArchive: false);
  }

  void showArchive() {
    state = state.copyWith(showArchive: true);
  }

  Future<void> addFolder(String planId, String name) async {
    try {
      await api.createFolder(
        trainingPlanId: planId,
        name: name,
        order: state.folders.length,
      );
      await loadFolders(planId);
    } catch (e) {
      final error = GlobalErrorHandler.handle(e);
      state = state.copyWith(error: error.message);
    }
  }

  void renameFolder(String folderId, String newName) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;
        return folder.copyWith(name: newName);
      }).toList(),
    );
  }

  Future<void> deleteFolder(String planId, String folderId) async {
    try {
      await api.deleteFolder(folderId);
      await loadFolders(planId);
    } catch (e) {
      final error = GlobalErrorHandler.handle(e);
      state = state.copyWith(error: error.message);
    }
  }

  void archiveFolder(String folderId) {
    TrainingFolder? archived;

    final updated = state.folders.where((f) {
      if (f.id == folderId) {
        archived = f;
        return false;
      }
      return true;
    }).toList();

    if (archived == null) return;

    state = state.copyWith(
      folders: updated,
      archivedFolders: [...state.archivedFolders, archived!],
    );
  }

  void reorderFolders(int oldIndex, int newIndex) {
    final list = [...state.folders];

    if (newIndex > oldIndex) newIndex--;

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    state = state.copyWith(folders: list);
  }

  void addPlan(String folderId, String name) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        final updatedPlans = [
          ...folder.plans,
          TrainingPlan(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            exercises: [],
          ),
        ];

        return folder.copyWith(plans: updatedPlans);
      }).toList(),
    );
  }

  void renamePlan(String folderId, String planId, String newName) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        final updatedPlans = folder.plans.map((plan) {
          if (plan.id != planId) return plan;
          return plan.copyWith(name: newName);
        }).toList();

        return folder.copyWith(plans: updatedPlans);
      }).toList(),
    );
  }

  void deletePlan(String folderId, String planId) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        return folder.copyWith(
          plans: folder.plans.where((p) => p.id != planId).toList(),
        );
      }).toList(),
    );
  }

  void archivePlan(String folderId, String planId) {
    TrainingPlan? archived;

    final updatedFolders = state.folders.map((folder) {
      if (folder.id != folderId) return folder;

      final plans = [...folder.plans];
      final index = plans.indexWhere((p) => p.id == planId);

      if (index == -1) return folder;

      final removed = plans.removeAt(index);
      archived = removed.copyWith(originFolderName: folder.name);

      return folder.copyWith(plans: plans);
    }).toList();

    if (archived == null) return;

    state = state.copyWith(
      folders: updatedFolders,
      archivedPlans: [...state.archivedPlans, archived!],
    );
  }

  void duplicatePlan(String folderId, String planId) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        final plans = [...folder.plans];
        final index = plans.indexWhere((p) => p.id == planId);
        if (index == -1) return folder;

        final original = plans[index];

        final duplicate = TrainingPlan(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: original.name,
          exercises: [...original.exercises],
        );

        plans.insert(index + 1, duplicate);

        return folder.copyWith(plans: plans);
      }).toList(),
    );
  }

  void movePlanUp(String folderId, String planId) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        final plans = [...folder.plans];
        final index = plans.indexWhere((p) => p.id == planId);
        if (index <= 0) return folder;

        final item = plans.removeAt(index);
        plans.insert(index - 1, item);

        return folder.copyWith(plans: plans);
      }).toList(),
    );
  }

  void movePlanDown(String folderId, String planId) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        final plans = [...folder.plans];
        final index = plans.indexWhere((p) => p.id == planId);
        if (index == -1 || index == plans.length - 1) return folder;

        final item = plans.removeAt(index);
        plans.insert(index + 1, item);

        return folder.copyWith(plans: plans);
      }).toList(),
    );
  }

  void addExercise(String folderId, String planId, Exercise exercise) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;

        final updatedPlans = folder.plans.map((plan) {
          if (plan.id != planId) return plan;
          return plan.copyWith(exercises: [...plan.exercises, exercise]);
        }).toList();

        return folder.copyWith(plans: updatedPlans);
      }).toList(),
    );
  }

  void importExercise(String folderId, String planId, Exercise exercise) {
    final updatedFolders = state.folders.map((folder) {
      if (folder.id != folderId) return folder;

      return folder.copyWith(
        plans: folder.plans.map((plan) {
          if (plan.id != planId) return plan;
          return plan.copyWith(exercises: [...plan.exercises, exercise]);
        }).toList(),
      );
    }).toList();

    state = state.copyWith(folders: updatedFolders);
  }

  void importMuscleGroup(
      String folderId,
      String planId,
      List<Exercise> exercises,
      ) {
    final updatedFolders = state.folders.map((folder) {
      if (folder.id != folderId) return folder;

      return folder.copyWith(
        plans: folder.plans.map((plan) {
          if (plan.id != planId) return plan;
          return plan.copyWith(
            exercises: [...plan.exercises, ...exercises],
          );
        }).toList(),
      );
    }).toList();

    state = state.copyWith(folders: updatedFolders);
  }

  void importPlan(String folderId, TrainingPlan plan) {
    state = state.copyWith(
      folders: state.folders.map((folder) {
        if (folder.id != folderId) return folder;
        return folder.copyWith(plans: [...folder.plans, plan]);
      }).toList(),
      archivedPlans:
      state.archivedPlans.where((p) => p.id != plan.id).toList(),
    );
  }

  void importFolder(TrainingFolder folder) {
    state = state.copyWith(
      folders: [...state.folders, folder],
      archivedFolders:
      state.archivedFolders.where((f) => f.id != folder.id).toList(),
    );
  }
}