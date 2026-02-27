import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_plan.dart';
import '../providers/workout_providers.dart';
import 'training_folder_screen.dart';

class TrainingPlanScreen extends ConsumerWidget {
  const TrainingPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(trainingPlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Plans'),
      ),
      body: plansAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error: $err')),
        data: (plans) => _PlansList(plans: plans),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Training Plan'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Plan name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                final api = ref.read(workoutApiServiceProvider);

                await api.createTrainingPlan(name);

                ref.invalidate(trainingPlansProvider);

                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class _PlansList extends ConsumerWidget {
  final List<TrainingPlan> plans;

  const _PlansList({required this.plans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (plans.isEmpty) {
      return const Center(
        child: Text('No training plans yet.'),
      );
    }

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];

        return Dismissible(
          key: ValueKey(plan.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Plan'),
                content: Text('Delete "${plan.name}"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) async {
            final api = ref.read(workoutApiServiceProvider);

            await api.deleteTrainingPlan(plan.id);

            ref.invalidate(trainingPlansProvider);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${plan.name} deleted')),
            );
          },
          child: ListTile(
            title: Text(plan.name),
            subtitle: Text('${plan.folders.length} folders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrainingFolderScreen(
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