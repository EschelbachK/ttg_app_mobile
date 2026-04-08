import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../../../core/theme/app_theme.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise/exercise_selection_card.dart';
import '../widgets/exercise/exercise_tile.dart';
import '../models/training_plan.dart';

class MuscleGroupScreen extends ConsumerStatefulWidget {
  final String folderId;
  final TrainingPlan plan;
  final bool isArchived;

  const MuscleGroupScreen({
    super.key,
    required this.folderId,
    required this.plan,
    this.isArchived = false,
  });

  @override
  ConsumerState<MuscleGroupScreen> createState() =>
      _MuscleGroupScreenState();
}

class _MuscleGroupScreenState
    extends ConsumerState<MuscleGroupScreen> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    final folder = state.folders.firstWhere(
          (f) => f.id == widget.folderId,
    );

    final exercises = folder.exercises;

    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset("assets/images/dashboard_bg.png",
                fit: BoxFit.cover)),
        Positioned.fill(
            child: Container(color: Colors.black.withOpacity(.55))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white54),
                onPressed: () => Navigator.pop(context)),
            title: Text(folder.name,
                style: const TextStyle(color: Colors.white)),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              if (!widget.isArchived)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  child: TTGGlowBorder(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter:
                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: ExpansionTile(
                          trailing: const Icon(Icons.add,
                              color: AppTheme.primaryRed),
                          onExpansionChanged: (v) =>
                              setState(() => open = v),
                          title: const Center(
                            child: Text(
                              "Übung hinzufügen",
                              style: TextStyle(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: [
                            ExerciseSelectionCard(
                              folderId: folder.id,
                              planId: widget.plan.id,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: exercises.isEmpty
                    ? const Center(
                  child: Text(
                    'Noch keine Übungen hinzugefügt',
                    style:
                    TextStyle(color: Colors.white54),
                  ),
                )
                    : ListView.builder(
                  padding:
                  const EdgeInsets.only(bottom: 100),
                  itemCount: exercises.length,
                  itemBuilder: (_, i) =>
                      ExerciseTile(
                        exercise: exercises[i],
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}