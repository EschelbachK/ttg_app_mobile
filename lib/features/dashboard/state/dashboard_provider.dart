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

  void showPlans() {
    state = state.copyWith(showArchive: false);
  }

  void showArchive() {
    state = state.copyWith(showArchive: true);
  }

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

  void renameFolder(String folderId, String newName) {

    state = state.copyWith(
      folders: state.folders.map((folder) {

        if (folder.id != folderId) return folder;

        return folder.copyWith(name: newName);

      }).toList(),
    );
  }

  void deleteFolder(String folderId) {

    state = state.copyWith(
      folders: state.folders
          .where((f) => f.id != folderId)
          .toList(),
    );
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

    if (archived == null) return; // ✅ FIX

    state = state.copyWith(
      folders: updated,
      archivedFolders: [
        ...state.archivedFolders,
        archived!,
      ],
    );
  }

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

  void renamePlan(
      String folderId,
      String planId,
      String newName,
      ) {

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

  void archivePlan(String folderId, String planId) {

    TrainingPlan? archived;

    final updatedFolders = state.folders.map((folder) {

      if (folder.id != folderId) {
        return folder;
      }

      final plans = [...folder.plans];

      final index = plans.indexWhere((p) => p.id == planId);

      if (index == -1) return folder; // ✅ FIX

      archived = plans.removeAt(index);

      return folder.copyWith(
        plans: plans,
      );

    }).toList();

    if (archived == null) return; // ✅ FIX

    state = state.copyWith(
      folders: updatedFolders,
      archivedPlans: [
        ...state.archivedPlans,
        archived!,
      ],
    );
  }

  void duplicatePlan(String folderId, String planId) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) return folder;

        final plans = [...folder.plans];

        final index = plans.indexWhere((p) => p.id == planId);

        if (index == -1) return folder; // ✅ FIX

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

        if (index <= 0) return folder; // ✅ FIX

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

        if (index == -1 || index == plans.length - 1) return folder; // ✅ FIX

        final item = plans.removeAt(index);

        plans.insert(index + 1, item);

        return folder.copyWith(plans: plans);

      }).toList(),
    );
  }

  void moveExerciseUp(
      String folderId,
      String planId,
      String exerciseId,
      ) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) return folder;

        final updatedPlans = folder.plans.map((plan) {

          if (plan.id != planId) return plan;

          final exercises = [...plan.exercises];

          final index =
          exercises.indexWhere((e) => e.id == exerciseId);

          if (index <= 0) return plan; // ✅ FIX

          final item = exercises.removeAt(index);

          exercises.insert(index - 1, item);

          return plan.copyWith(exercises: exercises);

        }).toList();

        return folder.copyWith(plans: updatedPlans);

      }).toList(),
    );
  }

  void moveExerciseDown(
      String folderId,
      String planId,
      String exerciseId,
      ) {

    state = state.copyWith(

      folders: state.folders.map((folder) {

        if (folder.id != folderId) return folder;

        final updatedPlans = folder.plans.map((plan) {

          if (plan.id != planId) return plan;

          final exercises = [...plan.exercises];

          final index =
          exercises.indexWhere((e) => e.id == exerciseId);

          if (index == -1 || index == exercises.length - 1) return plan; // ✅ FIX

          final item = exercises.removeAt(index);

          exercises.insert(index + 1, item);

          return plan.copyWith(exercises: exercises);

        }).toList();

        return folder.copyWith(plans: updatedPlans);

      }).toList(),
    );
  }

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
}