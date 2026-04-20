import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_state_provider.dart';
import 'sync_state.dart';

class SyncStatusListener extends ConsumerWidget {
  final Widget child;

  const SyncStatusListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SyncStatus>(syncStateProvider, (prev, next) {
      switch (next) {
        case SyncStatus.syncing:
          _show(context, "Synchronisiere...");
          break;
        case SyncStatus.success:
          _show(context, "Erfolgreich synchronisiert");
          break;
        case SyncStatus.error:
          _show(context, "Sync fehlgeschlagen");
          break;
        default:
          break;
      }
    });

    return child;
  }
}

void _show(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}