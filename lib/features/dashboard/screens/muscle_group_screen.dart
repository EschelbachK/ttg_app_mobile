import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../../../core/theme/app_theme.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise/exercise_selection_card.dart';
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
  ConsumerState<MuscleGroupScreen> createState() => _MuscleGroupScreenState();
}

class _MuscleGroupScreenState extends ConsumerState<MuscleGroupScreen> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final folder = ref.watch(dashboardProvider).folders.firstWhere(
          (f) => f.id == widget.folderId,
      orElse: () => throw Exception('Folder not found'),
    );

    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset("assets/images/dashboard_bg.png", fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(.55))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white54),
                onPressed: () => Navigator.pop(context)),
            title: Text(folder.name, style: const TextStyle(color: Colors.white)),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              if (!widget.isArchived)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TTGGlowBorder(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: ExpansionTile(
                          trailing: const Icon(Icons.add, color: AppTheme.primaryRed),
                          onExpansionChanged: (v) => setState(() => open = v),
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
                                folderId: folder.id, planId: widget.plan.id)
                          ],
                        ),
                      ),
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