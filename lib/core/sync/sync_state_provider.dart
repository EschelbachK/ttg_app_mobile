import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_state.dart';

final syncStateProvider =
StateNotifierProvider<SyncStateNotifier, SyncStatus>(
      (ref) => SyncStateNotifier(),
);

class SyncStateNotifier extends StateNotifier<SyncStatus> {
  SyncStateNotifier() : super(SyncStatus.idle);

  void setSyncing() => state = SyncStatus.syncing;
  void setSuccess() => state = SyncStatus.success;
  void setError() => state = SyncStatus.error;
  void setOffline() => state = SyncStatus.offline;
  void reset() => state = SyncStatus.idle;
}