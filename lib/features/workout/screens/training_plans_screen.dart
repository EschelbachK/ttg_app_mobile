import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_plan.dart';
import '../providers/workout_providers.dart';
import 'training_folders_screen.dart';

class TrainingPlansScreen extends ConsumerWidget {
  const TrainingPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(trainingPlansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Trainingspläne")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: plansAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Error: $err')),
        data: (plans) => _PlanList(plans: plans),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Neuer Trainingsplan"),
        content: TextField(
          controller: controller,
          decoration:
          const InputDecoration(labelText: "Titel"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              final api =
              ref.read(workoutApiServiceProvider);

              await api.createTrainingPlan(name);
              ref.invalidate(trainingPlansProvider);

              Navigator.pop(context);
            },
            child: const Text("Erstellen"),
          )
        ],
      ),
    );
  }
}

class _PlanList extends StatelessWidget {
  final List<TrainingPlan> plans;

  const _PlanList({required this.plans});

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return const Center(
        child: Text("Keine Trainingspläne vorhanden"),
      );
    }

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];

        return Card(
          child: ListTile(
            title: Text(plan.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrainingFoldersScreen(
                    planId: plan.id,
                    planName: plan.name,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}