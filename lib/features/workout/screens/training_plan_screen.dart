import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/workout_providers.dart';
import '../models/training_plan.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
        data: (plans) => _PlansList(plans: plans),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create Plan
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PlansList extends StatelessWidget {
  final List<TrainingPlan> plans;

  const _PlansList({required this.plans});

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return const Center(
        child: Text('No training plans yet.'),
      );
    }

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];

        return ListTile(
          title: Text(plan.name),
          subtitle: Text('${plan.folders.length} folders'),
          onTap: () {
            // TODO: Navigate to folders
          },
        );
      },
    );
  }
}