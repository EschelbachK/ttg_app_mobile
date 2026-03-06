import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_service_provider.dart';
import '../models/training_plan.dart';
import 'training_folders_screen.dart';

class TrainingPlansScreen extends ConsumerStatefulWidget {
  const TrainingPlansScreen({super.key});

  @override
  ConsumerState<TrainingPlansScreen> createState() =>
      _TrainingPlansScreenState();
}

class _TrainingPlansScreenState
    extends ConsumerState<TrainingPlansScreen> {

  List<TrainingPlan> plans = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    try {
      final api = ref.read(apiServiceProvider);
      final data = await api.getTrainingPlans();

      setState(() {
        plans = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Plans error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Trainingspläne")),
      body: plans.isEmpty
          ? const Center(child: Text("Keine Trainingspläne"))
          : ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];

          return Card(
            child: ListTile(
              title: Text(plan.name),
              trailing: const Icon(Icons.chevron_right),
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
      ),
    );
  }
}