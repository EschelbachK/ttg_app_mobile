import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/state/exercise_catalog_provider.dart';
import '../../catalog/models/exercise_catalog_item.dart';

class ExerciseCategoryScreen extends ConsumerWidget {
  final String category;
  final String folderId;
  final String planId;

  const ExerciseCategoryScreen({
    super.key,
    required this.category,
    required this.folderId,
    required this.planId,
  });

  static const _map = {
    "brustmuskulatur": "BRUST",
    "rücken": "RUECKEN",
    "beine": "BEINE",
    "schulter": "SCHULTERN",
    "schultern": "SCHULTERN",
    "bizeps": "BIZEPS",
    "trizeps": "TRIZEPS",
    "bauchmuskulatur": "BAUCH",
    "nacken": "NACKEN",
    "unterarme": "UNTERARME",
    "cardio": "CARDIO",
    "ganzkörpertraining": "GANZKOERPER",
  };

  String _mapCategory(String c) =>
      _map[c.toLowerCase()] ?? c.toUpperCase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(exerciseCatalogProvider);
    final mapped = _mapCategory(category);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,
        title: Text(category,
            style: const TextStyle(color: Colors.white)),
      ),
      body: async.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text("Error: $e",
              style: const TextStyle(color: Colors.white)),
        ),
        data: (items) {
          final list =
          items.where((e) => e.bodyRegion == mapped).toList();

          if (list.isEmpty) {
            return const Center(
              child: Text("Keine Übungen gefunden",
                  style: TextStyle(color: Colors.white54)),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final e = list[i];

              return Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1F23),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(e.name,
                      style:
                      const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "${e.primaryMuscle} • ${e.equipment}",
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.white38),
                ),
              );
            },
          );
        },
      ),
    );
  }
}