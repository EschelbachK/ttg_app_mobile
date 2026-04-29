import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _index(String location) => location.startsWith('/workout') ? 1 : 0;

  void _onTap(BuildContext context, String location, int i) {
    if (i == 0 && !location.startsWith('/dashboard')) {
      context.go('/dashboard');
    } else if (i == 1 && !location.startsWith('/workout')) {
      context.go('/workout');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _index(location);

    return Scaffold(
      backgroundColor: Colors.black,
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                onTap: (i) => _onTap(context, location, i),
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                iconSize: 20,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                selectedItemColor: const Color(0xFFFF3B30),
                unselectedItemColor: Colors.grey,
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