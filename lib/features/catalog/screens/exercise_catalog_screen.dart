import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/exercise_catalog_provider.dart';
import '../models/exercise_catalog_item.dart';

class ExerciseCatalogScreen extends ConsumerWidget {
  const ExerciseCatalogScreen({super.key});

  static const _baseUrl = "http://10.0.2.2:8080";

  String _img(String path) => path.isEmpty ? "" : "$_baseUrl$path";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(exerciseCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Exercises")),
      body: async.when(
        data: (items) => items.isEmpty
            ? const Center(child: Text("No exercises found"))
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final e = items[i];
            final img = _img(e.imageUrl);

            return Card(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: img.isNotEmpty
                    ? Image.network(img,
                    width: 40, height: 40, fit: BoxFit.cover)
                    : const Icon(Icons.fitness_center),
                title: Text(e.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle:
                Text("${e.bodyRegion} • ${e.equipment}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected: ${e.name}")),
                ),
              ),
            );
          },
        ),
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}