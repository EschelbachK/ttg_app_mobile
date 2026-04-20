import 'offline_queue.dart';
import 'offline_action.dart';
import '../../features/dashboard/api/dashboard_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_state_provider.dart';
import '../../features/settings/application/settings_provider.dart';

class SyncEngine {
  final DashboardApi api;
  final Ref ref;

  SyncEngine(this.api, this.ref);

  bool get _canSync {
    final s = ref.read(settingsProvider);
    return !s.offlineMode && s.syncEnabled;
  }

  Future<void> processQueue() async {
    if (!_canSync) return;

    final notifier = ref.read(syncStateProvider.notifier);
    final actions = await OfflineQueue.getAll();
    if (actions.isEmpty) return;

    notifier.setSyncing();

    final failed = <OfflineAction>[];

    for (final a in actions) {
      if (!_canSync) break;
      try {
        await _handle(a);
      } catch (_) {
        failed.add(a);
      }
    }

    if (failed.isEmpty) {
      await OfflineQueue.clear();
      notifier.setSuccess();
    } else {
      await OfflineQueue.replaceAll(failed);
      notifier.setError();
    }

    Future.delayed(const Duration(seconds: 2), notifier.reset);
  }

  Future<void> _handle(OfflineAction a) async {
    switch (a.type) {
      case 'create_plan':
        await api.createTrainingPlan(a.payload['name']);
        break;
      case 'rename_plan':
        await api.updateTrainingPlan(a.payload['id'], a.payload['name']);
        break;
      case 'delete_plan':
        await api.deleteTrainingPlan(a.payload['id']);
        break;
      case 'archive_plan':
        await api.archiveTrainingPlan(a.payload['id']);
        break;
      case 'restore_plan':
        await api.restoreTrainingPlan(a.payload['id']);
        break;
      case 'create_folder':
        await api.createFolder(
          trainingPlanId: a.payload['planId'],
          name: a.payload['name'],
          order: 0,
        );
        break;
      case 'delete_folder':
        await api.deleteFolder(a.payload['id']);
        break;
      case 'duplicate_folder':
        await api.duplicateFolder(a.payload['id']);
        break;
      case 'archive_folder':
        await api.archiveFolder(a.payload['id']);
        break;
      case 'restore_folder':
        await api.restoreFolder(a.payload['id']);
        break;
      case 'import_folder':
        await api.createFolder(
          trainingPlanId: a.payload['targetPlanId'],
          name: a.payload['name'],
          order: 0,
        );
        await api.restoreFolder(a.payload['folderId']);
        break;
      case 'create_exercise':
        await api.createExercise(
          planId: a.payload['planId'],
          folderId: a.payload['folderId'],
          name: a.payload['name'],
          bodyRegion: "GANZKOERPER",
          sets: [],
        );
        break;
      case 'delete_exercise':
        await api.deleteExercise(
          planId: a.payload['planId'],
          folderId: a.payload['folderId'],
          exerciseId: a.payload['exerciseId'],
        );
        break;
    }
  }
}