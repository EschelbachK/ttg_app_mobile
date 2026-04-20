import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../offline/sync_provider.dart';

final connectivityProvider = Provider<void>((ref) {
  final connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? sub;

  sub = connectivity.onConnectivityChanged.listen((results) {
    final hasConnection =
    results.any((r) => r != ConnectivityResult.none);

    if (hasConnection) {
      ref.read(syncEngineProvider).processQueue();
    }
  });

  ref.onDispose(() => sub?.cancel());
});