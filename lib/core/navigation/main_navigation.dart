import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.startsWith('/workout')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouter.of(context).location;
    final index = _indexFromLocation(location);

    return Scaffold(
      body: child,
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: index,
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                iconSize: 20,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                selectedItemColor: const Color(0xFFFF3B30),
                unselectedItemColor: Colors.grey,
                onTap: (i) {
                  if (i == 0 && location != '/dashboard') {
                    context.go('/dashboard');
                  }
                  if (i == 1 && location != '/workout') {
                    context.go('/workout');
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: 'Workout',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}