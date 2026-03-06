import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          if (i == 0) context.go('/dashboard');
          if (i == 1) context.go('/workout');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(authProvider.notifier).logout();
          context.go('/login');
        },
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
      ),
    );
  }
}