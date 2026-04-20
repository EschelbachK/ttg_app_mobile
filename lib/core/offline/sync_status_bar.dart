import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_state_provider.dart';
import 'sync_state.dart';

class SyncStatusBar extends ConsumerWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStateProvider);

    if (status == SyncStatus.idle) return const SizedBox.shrink();

    String text;
    IconData icon;

    switch (status) {
      case SyncStatus.syncing:
        text = "Synchronisiere...";
        icon = Icons.sync;
        break;
      case SyncStatus.success:
        text = "Synchronisiert";
        icon = Icons.check_circle;
        break;
      case SyncStatus.error:
        text = "Sync fehlgeschlagen";
        icon = Icons.error;
        break;
      default:
        return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 36,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(color: Colors.red, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}