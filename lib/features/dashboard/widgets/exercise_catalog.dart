import 'package:flutter/material.dart';
import '../screens/exercise_category_screen.dart';

class ExerciseCatalog extends StatelessWidget {

  final String folderId;
  final String planId;

  const ExerciseCatalog({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {

    final categories = [

      "Bauchmuskulatur",
      "Beine",
      "Bizeps",
      "Brustmuskulatur",
      "Cardio",
      "Ganzkörpertraining",
      "Rücken",
      "Schulter",
      "Trizeps"

    ];

    return Container(

      height: 600,
      color: Colors.white,

      child: Column(
        children: [

          const Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Liste durchsuchen...",
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(

              itemCount: categories.length,

              itemBuilder: (context, index) {

                return ListTile(

                  title: Text(categories[index]),

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseCategoryScreen(
                          category: categories[index],
                          folderId: folderId,
                          planId: planId,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )

        ],
      ),
    );
  }
}