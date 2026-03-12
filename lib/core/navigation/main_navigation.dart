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
    final location = GoRouterState.of(context).matchedLocation;
    final index = _indexFromLocation(location);

    return Scaffold(
      body: child,
      backgroundColor: Colors.black,

      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF111418),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
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

          selectedItemColor: const Color(0xFFFF3B30),
          unselectedItemColor: Colors.grey,

          onTap: (i) {
            if (i == 0) context.go('/dashboard');
            if (i == 1) context.go('/workout');
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
    );
  }
}