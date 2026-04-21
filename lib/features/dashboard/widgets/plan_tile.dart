import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_plan.dart';
import '../utils/plan_tile_actions.dart';

class PlanTile extends ConsumerStatefulWidget {
  final String folderId;
  final TrainingPlan plan;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final bool isArchived;

  const PlanTile({
    super.key,
    required this.folderId,
    required this.plan,
    required this.onDelete,
    required this.onArchive,
    this.isArchived = false,
  });

  @override
  ConsumerState<PlanTile> createState() => _PlanTileState();
}

class _PlanTileState extends ConsumerState<PlanTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.plan;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(child: _title(context, p)),
                      widget.isArchived
                          ? _expandBtn()
                          : _actions(context, p),
                    ],
                  ),
                ),
                if (expanded && widget.isArchived)
                  Column(children: p.exercises.map(_exerciseRow).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, TrainingPlan p) => InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () => PlanTileActions.openPlan(
      context,
      ref,
      folderId: widget.folderId,
      plan: p,
      isArchived: widget.isArchived,
    ),
    child: Row(
      children: [
        const Icon(Icons.fitness_center, color: Color(0xFFFF3B30)),
        const SizedBox(width: 10),
        Text(p.name, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );

  Widget _expandBtn() => IconButton(
    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
    onPressed: () => setState(() => expanded = !expanded),
  );

  Widget _actions(BuildContext context, TrainingPlan p) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _icon(() => PlanTileActions.rename(context, ref, p), Icons.edit),
      _icon(() => PlanTileActions.delete(context, widget.onDelete), Icons.delete),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
        onSelected: (v) async {
          if (v == 'archive') widget.onArchive();
          if (v == 'delete') await PlanTileActions.delete(context, widget.onDelete);
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'archive', child: Text('Gruppe archivieren')),
          PopupMenuDivider(),
          PopupMenuItem(value: 'delete', child: Text('Löschen')),
        ],
      ),
    ],
  );

  Widget _icon(VoidCallback onTap, IconData icon) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Icon(icon, color: const Color(0xFFFF3B30), size: 18),
    ),
  );

  Widget _exerciseRow(e) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(e.name, style: const TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => PlanTileActions.importExercise(
            ref,
            widget.folderId,
            widget.plan.id,
            e,
          ),
          child: const Icon(Icons.download, color: Color(0xFFFF3B30), size: 20),
        ),
      ],
    ),
  );
}