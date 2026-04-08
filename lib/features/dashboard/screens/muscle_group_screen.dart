import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../../../core/theme/app_theme.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise/exercise_selection_card.dart';
import '../widgets/exercise/exercise_tile.dart';

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
    final plan = widget.plan;

    return Stack(children: [
      Positioned.fill(
        child: Image.asset("assets/images/dashboard_bg.png",
            fit: BoxFit.cover),
      ),
      Positioned.fill(
        child: Container(color: Colors.black.withOpacity(.55)),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
            const Icon(Icons.arrow_back, color: Colors.white54),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(plan.name,
              style: const TextStyle(color: Colors.white)),
        ),
        body: Column(children: [
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(plan.name.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
            const SizedBox(width: 10),
            if (!widget.isArchived)
              GestureDetector(
                onTap: () => showTTGInputDialog(
                  context: context,
                  title: "Muskelgruppe umbenennen",
                  buttonText: "Speichern",
                  initialValue: plan.name,
                  onSubmit: (v) => ref
                      .read(dashboardProvider.notifier)
                      .renameFolder(widget.folderId, v),
                ),
                child: const Icon(Icons.edit,
                    color: Colors.white54, size: 18),
              ),
          ]),
          const SizedBox(height: 20),
          if (!widget.isArchived)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TTGGlowBorder(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter:
                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                            Colors.white.withOpacity(.25)),
                      ),
                      child: ExpansionTile(
                        trailing: const Icon(Icons.add,
                            color: AppTheme.primaryRed),
                        onExpansionChanged: (v) =>
                            setState(() => open = v),
                        title: const Center(
                          child: Text("Übung hinzufügen",
                              style: TextStyle(
                                  color: AppTheme.primaryRed,
                                  fontWeight:
                                  FontWeight.bold)),
                        ),
                        children: [
                          ExerciseSelectionCard(
                            folderId: widget.folderId,
                            planId: plan.id,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!widget.isArchived) const SizedBox(height: 10),
          Expanded(
            child: plan.exercises.isEmpty
                ? const Center(
                child: Text("Noch keine Übungen hinzugefügt",
                    style:
                    TextStyle(color: Colors.white38)))
                : ListView.builder(
              itemCount: plan.exercises.length,
              itemBuilder: (_, i) =>
                  ExerciseTile(exercise: plan.exercises[i]),
            ),
          )
        ]),
      )
    ]);
  }
}