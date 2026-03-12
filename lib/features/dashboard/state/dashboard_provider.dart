import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_folder.dart';
import '../models/training_plan.dart';
import 'dart:math';

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, List<TrainingFolder>>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<List<TrainingFolder>> {
  DashboardNotifier() : super([]);

  final _rand = Random();
  String _id() => _rand.nextInt(99999999).toString();

  void addFolder(String name) {
    final newFolder = TrainingFolder(
      id: _id(),
      name: name,
      plans: [],
    );

    // ✅ Neue Liste → kein Mutations-Crash
    state = [...state, newFolder];
  }

  void deleteFolder(String folderId) {
    state = state.where((f) => f.id != folderId).toList();
  }

  void addPlan(String folderId, String name) {
    state = [
      for (final f in state)
        if (f.id == folderId)
          f.copyWith(
            plans: [
              ...f.plans,
              TrainingPlan(id: _id(), name: name),
            ],
          )
        else
          f
    ];
  }

  void deletePlan(String folderId, String planId) {
    state = [
      for (final f in state)
        if (f.id == folderId)
          f.copyWith(plans: f.plans.where((p) => p.id != planId).toList())
        else
          f
    ];
  }
}