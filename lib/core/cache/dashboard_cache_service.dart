import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dashboard/models/training_plan.dart';
import '../../features/dashboard/models/training_folder.dart';

class DashboardCache {
  static const _plans = 'cache_plans';
  static const _folders = 'cache_folders';
  static const _archivedPlans = 'cache_archived_plans';
  static const _archivedFolders = 'cache_archived_folders';

  static Future<void> save({
    required List<TrainingPlan> plans,
    required List<TrainingPlan> archivedPlans,
    required List<TrainingFolder> folders,
    required List<TrainingFolder> archivedFolders,
  }) async {
    final p = await SharedPreferences.getInstance();

    p.setString(_plans, jsonEncode(plans.map((e) => e.toJson()).toList()));
    p.setString(_archivedPlans, jsonEncode(archivedPlans.map((e) => e.toJson()).toList()));
    p.setString(_folders, jsonEncode(folders.map((e) => e.toJson()).toList()));
    p.setString(_archivedFolders, jsonEncode(archivedFolders.map((e) => e.toJson()).toList()));
  }

  static Future<({List<dynamic> archivedFolders, List<dynamic> archivedPlans, List<dynamic> folders, List<TrainingPlan> plans})?> load() async {
    final p = await SharedPreferences.getInstance();

    final plansRaw = p.getString(_plans);
    final archivedPlansRaw = p.getString(_archivedPlans);
    final foldersRaw = p.getString(_folders);
    final archivedFoldersRaw = p.getString(_archivedFolders);

    if (plansRaw == null) return null;

    List<TrainingPlan> parsePlans(String raw) =>
        (jsonDecode(raw) as List)
            .map((e) => TrainingPlan.fromJson(e))
            .toList();

    List<TrainingFolder> parseFolders(String raw) =>
        (jsonDecode(raw) as List)
            .map((e) => TrainingFolder.fromJson(e))
            .toList();

    return (
    plans: parsePlans(plansRaw),
    archivedPlans: archivedPlansRaw != null ? parsePlans(archivedPlansRaw) : [],
    folders: foldersRaw != null ? parseFolders(foldersRaw) : [],
    archivedFolders: archivedFoldersRaw != null ? parseFolders(archivedFoldersRaw) : [],
    );
  }
}