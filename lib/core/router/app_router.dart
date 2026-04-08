import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/screens/loading_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/navigation/dashboard_routes.dart';
import '../../features/dashboard/screens/training_set_screen.dart';
import '../../features/workout/screens/workoutplanscreen.dart';
import '../../features/workout/screens/workoutfolderscreen.dart';

import '../auth/auth_provider.dart';
import '../navigation/main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/loading', builder: (_, __) => const LoadingScreen()),
      ShellRoute(
        builder: (_, __, child) => MainNavigation(child: child),
        routes: [
          ...dashboardRoutes,
          GoRoute(
            path: '/workout',
            builder: (_, __) => const TrainingPlansScreen(),
            routes: [
              GoRoute(
                path: 'plans/:planId',
                builder: (_, s) {
                  final planId = s.pathParameters['planId'];
                  if (planId == null) return const Scaffold(body: Center(child: Text('Routing Error')));
                  return TrainingFoldersScreen(planId: planId);
                },
              ),
              GoRoute(
                path: 'exercises/:exerciseId/sets',
                builder: (_, s) {
                  final id = s.pathParameters['exerciseId'];
                  if (id == null) return const Scaffold(body: Center(child: Text('Routing Error')));
                  return TrainingSetScreen(exerciseId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loggedIn = auth.isLoggedIn;
      final loc = state.uri.toString();
      if (!loggedIn && loc != '/login') return '/login';
      if (loggedIn && (loc == '/login' || loc == '/loading')) return '/dashboard';
      return null;
    },
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}