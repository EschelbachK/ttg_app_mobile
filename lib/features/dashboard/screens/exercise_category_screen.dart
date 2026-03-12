import 'package:flutter/material.dart';

import '../widgets/exercise_input_dialog.dart';

class ExerciseCategoryScreen extends StatelessWidget {

  final String category;
  final String folderId;
  final String planId;

  const ExerciseCategoryScreen({
    super.key,
    required this.category,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {

    final exercises = [

      "Crunch",
      "Crunch am Gerät",
      "Crunch am Seilzug",
      "Crunch mit Gewicht",
      "Beinheben",
      "Beinheben Schrägbank"

    ];

    return Scaffold(

      appBar: AppBar(
        title: Text(category),
      ),

      body: ListView.builder(

        itemCount: exercises.length,

        itemBuilder: (context, index) {

          return ListTile(

            title: Text(exercises[index]),

            onTap: () {

              showDialog(
                context: context,
                builder: (_) => ExerciseInputDialog(
                  category: category,
                  name: exercises[index],
                  folderId: folderId,
                  planId: planId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}