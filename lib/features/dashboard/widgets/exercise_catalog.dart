import 'package:flutter/material.dart';
import '../screens/exercise_category_screen.dart';

class ExerciseCatalog extends StatefulWidget {

  final String folderId;
  final String planId;

  const ExerciseCatalog({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  State<ExerciseCatalog> createState() => _ExerciseCatalogState();
}

class _ExerciseCatalogState extends State<ExerciseCatalog> {

  String search = "";

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

  @override
  Widget build(BuildContext context) {

    final filtered = categories
        .where((c) => c.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(

      backgroundColor: const Color(0xFF0B0D10),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D10),
        elevation: 0,
        title: const Text(
          "Alle Übungen",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),

            child: TextField(

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(

                hintText: "Liste durchsuchen...",
                hintStyle: const TextStyle(color: Colors.white38),

                filled: true,
                fillColor: const Color(0xFF1B1F23),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (v) {
                setState(() {
                  search = v;
                });
              },
            ),
          ),

          /// CATEGORY LIST
          Expanded(

            child: ListView.builder(

              itemCount: filtered.length,

              itemBuilder: (context, index) {

                final category = filtered[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),

                  child: InkWell(

                    borderRadius: BorderRadius.circular(12),

                    hoverColor: const Color(0x22FF3B30),

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseCategoryScreen(
                            category: category,
                            folderId: widget.folderId,
                            planId: widget.planId,
                          ),
                        ),
                      );
                    },

                    child: Container(

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(

                        color: const Color(0xFF1B1F23),

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: const Color(0x22FFFFFF),
                        ),
                      ),

                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}