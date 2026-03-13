import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_folder.dart';
import '../models/training_plan.dart';
import '../models/exercise.dart';

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
        (ref) => DashboardNotifier());

class DashboardState {

  final List<TrainingFolder> folders;
  final List<TrainingFolder> archivedFolders;
  final List<TrainingPlan> archivedPlans;
  final bool showArchive;

  DashboardState({
    required this.folders,
    required this.archivedFolders,
    required this.archivedPlans,
    required this.showArchive,
  });

  DashboardState copyWith({
    List<TrainingFolder>? folders,
    List<TrainingFolder>? archivedFolders,
    List<TrainingPlan>? archivedPlans,
    bool? showArchive,
  }) {
    return DashboardState(
      folders: folders ?? this.folders,
      archivedFolders: archivedFolders ?? this.archivedFolders,
      archivedPlans: archivedPlans ?? this.archivedPlans,
      showArchive: showArchive ?? this.showArchive,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {

  DashboardNotifier()
      : super(
    DashboardState(
      folders: [],
      archivedFolders: [],
      archivedPlans: [],
      showArchive: false,
    ),
  );

  /// SWITCH VIEW
  void showPlans() {
    state = state.copyWith(showArchive: false);
  }

  void showArchive() {
    state = state.copyWith(showArchive: true);
  }

  /// CREATE FOLDER
  void addFolder(String name) {

    final folder = TrainingFolder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      plans: [],
    );

    state = state.copyWith(
      folders: [...state.folders, folder],
    );
  }

  /// DELETE FOLDER
  void deleteFolder(String folderId) {

    state = state.copyWith(
      folders: state.folders
          .where((f) => f.id != folderId)
          .toList(),
    );
  }

  /// ARCHIVE FOLDER
  void archiveFolder(String folderId) {

    TrainingFolder? archived;

    final updated = state.folders.where((f) {

      if (f.id == folderId) {
        archived = f;
        return false;
      }

      return true;

    }).toList();

    state = state.copyWith(
      folders: updated,
      archivedFolders: [
        ...state.archivedFolders,
        archived!,
      ],
    );
  }

  /// DRAG SORT FOLDERS
  void reorderFolders(int oldIndex, int newIndex) {

    final list = [...state.folders];

    if (newIndex > oldIndex) {
      newIndex--;
    }

    final item = list.removeAt(oldIndex);

    list.insert(newIndex, item);

    state = state.copyWith(
      folders: list,
    );
  }

  /// CREATE MUSCLE GROUP
  void addPlan(String folderId, String name) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) {
          return folder;
        }

        final updatedPlans = [

          ...folder.plans,

          TrainingPlan(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            exercises: [],
          ),

        ];

        return folder.copyWith(
          plans: updatedPlans,
        );

      }).toList(),

    );
  }

  /// DELETE MUSCLE GROUP
  void deletePlan(String folderId, String planId) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) {
          return folder;
        }

        return folder.copyWith(
          plans: folder.plans
              .where((p) => p.id != planId)
              .toList(),
        );

      }).toList(),

    );
  }

  /// ARCHIVE MUSCLE GROUP
  void archivePlan(String folderId, String planId) {

    TrainingPlan? archived;

    final updatedFolders = state.folders.map((folder) {

      if (folder.id != folderId) {
        return folder;
      }

      final plans = [...folder.plans];

      final index = plans.indexWhere((p) => p.id == planId);

      archived = plans.removeAt(index);

      return folder.copyWith(
        plans: plans,
      );

    }).toList();

    state = state.copyWith(
      folders: updatedFolders,
      archivedPlans: [
        ...state.archivedPlans,
        archived!,
      ],
    );
  }

  /// ADD EXERCISE
  void addExercise(
      String folderId,
      String planId,
      Exercise exercise,
      ) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) {
          return folder;
        }

        final updatedPlans = folder.plans.map((plan) {

          if (plan.id != planId) {
            return plan;
          }

          final updatedExercises = [
            ...plan.exercises,
            exercise,
          ];

          return plan.copyWith(
            exercises: updatedExercises,
          );

        }).toList();

        return folder.copyWith(
          plans: updatedPlans,
        );

      }).toList(),

    );
  }

  /// DELETE EXERCISE
  void deleteExercise(
      String folderId,
      String planId,
      String exerciseId,
      ) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) {
          return folder;
        }

        final updatedPlans = folder.plans.map((plan) {

          if (plan.id != planId) {
            return plan;
          }

          return plan.copyWith(
            exercises: plan.exercises
                .where((e) => e.id != exerciseId)
                .toList(),
          );

        }).toList();

        return folder.copyWith(
          plans: updatedPlans,
        );

      }).toList(),

    );
  }

  /// DRAG SORT EXERCISES
  void reorderExercises(
      String folderId,
      String planId,
      int oldIndex,
      int newIndex,
      ) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) {
          return folder;
        }

        final updatedPlans = folder.plans.map((plan) {

          if (plan.id != planId) {
            return plan;
          }

          final list = [...plan.exercises];

          if (newIndex > oldIndex) {
            newIndex--;
          }

          final item = list.removeAt(oldIndex);

          list.insert(newIndex, item);

          return plan.copyWith(
            exercises: list,
          );

        }).toList();

        return folder.copyWith(
          plans: updatedPlans,
        );

      }).toList(),

    );
  }
}