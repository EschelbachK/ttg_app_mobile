import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_catalog.dart';

class ExerciseCatalogScreen extends ConsumerStatefulWidget {
  final String folderId;

  const ExerciseCatalogScreen({
    super.key,
    required this.folderId,
  });

  @override
  ConsumerState<ExerciseCatalogScreen> createState() =>
      _ExerciseCatalogScreenState();
}

class _ExerciseCatalogScreenState
    extends ConsumerState<ExerciseCatalogScreen> {

  List<ExerciseCatalog> exercises = [];

  ProviderListenable<dynamic>? get apiServiceProvider => null;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final api = ref.read(apiServiceProvider!);

    final data =
    await api.getCatalogExercises("BRUST");

    setState(() {
      exercises = data;
    });
  }

  Future<void> addExercise(String id) async {
    final api = ref.read(apiServiceProvider!);

    await api.addExerciseToFolder(
      widget.folderId,
      id,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Übung auswählen"),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];

          return ListTile(
            title: Text(ex.name),
            onTap: () => addExercise(ex.id),
          );
        },
      ),
    );
  }
}