import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_confirm_dialog.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../widgets/exercise/exercise_selection_card.dart';
import 'package:ttg_app_mobile/features/dashboard/widgets/exercise/exercise_tile.dart';

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
  late bool open; // 🔥 WICHTIG

  @override
  void initState() {
    super.initState();

    final folder = ref.read(dashboardProvider)
        .folders
        .firstWhere((f) => f.id == widget.folderId);

    final hasExercises = folder.exercises.isNotEmpty;

    // 🔥 LOGIK:
    open = !hasExercises;
  }

  @override
  Widget build(BuildContext context) {
    final folder = ref
        .watch(dashboardProvider)
        .folders
        .firstWhere((f) => f.id == widget.folderId);

    final exercises = folder.exercises;

    return Stack(
      children: [
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
            centerTitle: true,
            leading: IconButton(
              icon:
              const Icon(Icons.arrow_back, color: Colors.white54),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(folder.name,
                style: const TextStyle(color: Colors.white)),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),

              // 🔴 ADD EXERCISE SECTION
              if (!widget.isArchived)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  child: TTGGlowBorder(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter:
                        ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.35),
                            borderRadius:
                            BorderRadius.circular(22),
                            border: Border.all(
                                color:
                                Colors.white.withOpacity(.12)),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => open = !open),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryRed
                                              .withOpacity(.15),
                                          borderRadius:
                                          BorderRadius.circular(
                                              8),
                                        ),
                                        child: const Icon(Icons.add,
                                            size: 16,
                                            color: AppTheme
                                                .primaryRed),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text(
                                          "Übung hinzufügen",
                                          style: TextStyle(
                                            color: AppTheme
                                                .primaryRed,
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: open ? .5 : 0,
                                        duration:
                                        const Duration(
                                            milliseconds: 200),
                                        child: const Icon(
                                          Icons
                                              .keyboard_arrow_down,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // 🔥 AUTO CLOSE + STATE LOGIK
                              AnimatedSize(
                                duration: const Duration(
                                    milliseconds: 200),
                                child: open
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      bottom: 12),
                                  child:
                                  ExerciseSelectionCard(
                                    folderId: folder.id,
                                    planId:
                                    widget.plan.id,
                                    onAdded: () {
                                      setState(() =>
                                      open = false);
                                    },
                                  ),
                                )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // 🔴 EXERCISE LIST
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
                  itemBuilder: (_, i) {
                    final e = exercises[i];

                    return ExerciseTile(
                      exercise: e,
                      onDelete: () async {
                        final ok =
                        await showTTGConfirmDialog(
                          context: context,
                          title: "Übung löschen",
                          subtitle:
                          "Wirklich löschen?",
                        );
                        if (!ok) return;

                        ref
                            .read(dashboardProvider
                            .notifier)
                            .removeExercise(
                          planId:
                          widget.plan.id,
                          folderId: folder.id,
                          exerciseId: e.id,
                        );

                        // 🔥 BONUS: wenn letzte Übung gelöscht → wieder öffnen
                        if (exercises.length == 1) {
                          setState(() => open = true);
                        }
                      },
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