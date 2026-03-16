import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/lib/core/ui/ttg_glow_border.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise_selection_card.dart';
import '../widgets/exercise_tile.dart';

class MuscleGroupScreen extends ConsumerStatefulWidget {

  final String folderId;
  final TrainingPlan plan;

  const MuscleGroupScreen({
    super.key,
    required this.folderId,
    required this.plan,
  });

  @override
  ConsumerState<MuscleGroupScreen> createState() => _MuscleGroupScreenState();
}

class _MuscleGroupScreenState extends ConsumerState<MuscleGroupScreen> {

  bool addExerciseExpanded = false;

  @override
  Widget build(BuildContext context) {

    final dashboardState = ref.watch(dashboardProvider);

    TrainingPlan currentPlan = widget.plan;

    for (final folder in dashboardState.folders) {

      if (folder.id == widget.folderId) {

        for (final p in folder.plans) {

          if (p.id == widget.plan.id) {
            currentPlan = p;
          }

        }

      }

    }

    return Stack(
      children: [

        /// BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            "assets/images/dashboard_bg.png",
            fit: BoxFit.cover,
          ),
        ),

        /// DARK OVERLAY
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
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFFF3B30),
              ),
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

              /// TITLE
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

                  const SizedBox(width: 8),

                  InkWell(

                    onTap: () async {

                      final controller =
                      TextEditingController(text: currentPlan.name);

                      final newName = await showDialog<String>(

                        context: context,

                        builder: (context) {

                          return AlertDialog(

                            backgroundColor: const Color(0xFF1B1F23),

                            title: const Text(
                              "Muskelgruppe umbenennen",
                              style: TextStyle(color: Colors.white),
                            ),

                            content: TextField(
                              controller: controller,
                              style: const TextStyle(color: Colors.white),
                            ),

                            actions: [

                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Abbrechen"),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, controller.text);
                                },
                                child: const Text("Speichern"),
                              ),

                            ],
                          );
                        },
                      );

                      if (newName != null && newName.isNotEmpty) {

                        ref
                            .read(dashboardProvider.notifier)
                            .renamePlan(
                          widget.folderId,
                          currentPlan.id,
                          newName,
                        );

                      }

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

              /// ADD EXERCISE BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: TTGGlowBorder(

                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(20),

                    child: BackdropFilter(

                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),

                        child: ExpansionTile(

                          trailing: const Icon(
                            Icons.add,
                            color: Color(0xFFFF3B30),
                          ),

                          onExpansionChanged: (v) {
                            setState(() {
                              addExerciseExpanded = v;
                            });
                          },

                          collapsedIconColor: Colors.white54,
                          iconColor: Colors.white,

                          title: const Center(
                            child: Text(
                              "Übung hinzufügen",
                              style: TextStyle(
                                color: Color(0xFFFF3B30),
                                fontWeight: FontWeight.bold,
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

              const SizedBox(height: 10),

              /// EXERCISES
              Expanded(

                child: currentPlan.exercises.isEmpty

                    ? const Center(
                  child: Text(
                    "Noch keine Übungen hinzugefügt",
                    style: TextStyle(color: Colors.white38),
                  ),
                )

                    : ListView.builder(

                  itemCount: currentPlan.exercises.length,

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