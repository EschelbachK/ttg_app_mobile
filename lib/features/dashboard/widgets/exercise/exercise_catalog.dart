import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../screens/exercise_category_screen.dart';

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
    "Bauch",
    "Beine",
    "Bizeps",
    "Brust",
    "Cardio",
    "Ganzkörper",
    "Rücken",
    "Schulter",
    "Trizeps"
  ];

  IconData getCategoryIcon(String category) {
    return PhosphorIcons.barbell(PhosphorIconsStyle.fill);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = categories
        .where((c) =>
        c.toLowerCase().contains(search.toLowerCase()))
        .toList()
      ..sort((a, b) =>
          a.toLowerCase().compareTo(b.toLowerCase()));

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Kategorie suchen...",
                hintStyle:
                const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1B1F23),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) =>
                  setState(() => search = v),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final category = filtered[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ExerciseCategoryScreen(
                              category: category,
                              folderId: widget.folderId,
                              planId: widget.planId,
                            ),
                      ),
                    );
                  },
                  child: _PremiumCard(
                    title: category,
                    icon: getCategoryIcon(category),
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

class _PremiumCard extends StatefulWidget {
  final String title;
  final IconData icon;

  const _PremiumCard({
    required this.title,
    required this.icon,
  });

  @override
  State<_PremiumCard> createState() =>
      _PremiumCardState();
}

class _PremiumCardState extends State<_PremiumCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () =>
          setState(() => pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: pressed ? 0.96 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x22FF3B30),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFFFF3B30),
                  size: 18,
                ),
              ),
              const Spacer(),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}