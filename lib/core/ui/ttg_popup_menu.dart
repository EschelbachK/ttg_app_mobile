import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TTGPopupMenu extends StatelessWidget {
  final List<PopupMenuEntry<String>> items;
  final void Function(String)? onSelected;
  final Widget icon;

  const TTGPopupMenu({
    super.key,
    required this.items,
    this.onSelected,
    this.icon = const Icon(
      Icons.more_vert,
      color: Colors.white54,
      size: 18,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: PopupMenuButton<String>(
        icon: icon,
        onSelected: onSelected,
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),

                    // Glas Look
                    color: Colors.black.withOpacity(0.55),

                    // ✅ GLEICH WIE TRAINING PLAN CARD
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),

                    // Subtle Shadow (kein rot)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}