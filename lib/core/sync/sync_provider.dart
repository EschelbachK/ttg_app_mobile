import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_provider.dart';
import '../../features/dashboard/api/dashboard_api.dart';
import 'sync_engine.dart';

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    DashboardApi(ref.read(dioProvider)),
    ref,
  );
});