import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/ttg_glow_border.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise/exercise_selection_card.dart';
import '../widgets/exercise/exercise_tile.dart';
import '../../../core/theme/app_theme.dart';

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
  bool addExerciseExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentPlan = widget.plan;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/dashboard_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.55),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white54),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              currentPlan.name,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),

              /// TITLE + EDIT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentPlan.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 10),

                  if (!widget.isArchived)
                    GestureDetector(
                      onTap: () {
                        final controller =
                        TextEditingController(
                            text: currentPlan.name);

                        showDialog(
                          context: context,
                          builder: (dialogContext) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Muskelgruppe umbenennen",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: controller,
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                dialogContext),
                                        child:
                                        const Text("Abbrechen"),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        style:
                                        ElevatedButton
                                            .styleFrom(
                                          backgroundColor:
                                          AppTheme
                                              .primaryRed,
                                        ),
                                        onPressed: () {
                                          final newName =
                                          controller.text
                                              .trim();
                                          if (newName
                                              .isEmpty) return;

                                          Navigator.pop(
                                              dialogContext);

                                          ref
                                              .read(
                                              dashboardProvider
                                                  .notifier)
                                              .renameFolder(
                                            widget.folderId,
                                            newName,
                                          );
                                        },
                                        child: const Text(
                                            "Speichern"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white54,
                        size: 18,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              /// ADD EXERCISE
              if (!widget.isArchived)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  child: TTGGlowBorder(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.06),
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.25),
                            ),
                          ),
                          child: ExpansionTile(
                            trailing: const Icon(
                              Icons.add,
                              color: AppTheme.primaryRed,
                            ),
                            onExpansionChanged: (v) {
                              setState(() {
                                addExerciseExpanded = v;
                              });
                            },
                            title: const Center(
                              child: Text(
                                "Übung hinzufügen",
                                style: TextStyle(
                                  color:
                                  AppTheme.primaryRed,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                            children: [
                              ExerciseSelectionCard(
                                folderId: widget.folderId,
                                planId: currentPlan.id,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              if (!widget.isArchived)
                const SizedBox(height: 10),

              /// LIST
              Expanded(
                child: currentPlan.exercises.isEmpty
                    ? const Center(
                  child: Text(
                    "Noch keine Übungen hinzugefügt",
                    style: TextStyle(
                        color: Colors.white38),
                  ),
                )
                    : ListView.builder(
                  itemCount:
                  currentPlan.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise =
                    currentPlan.exercises[index];

                    return ExerciseTile(
                      exercise: exercise,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}