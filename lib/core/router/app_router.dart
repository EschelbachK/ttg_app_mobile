import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/screens/loading_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/navigation/dashboard_routes.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/workout/presentation/screens/workout_start_screen.dart';
import '../../features/workout/presentation/screens/workout_active_screen.dart';
import '../../features/workout/presentation/screens/workout_redirect_screen.dart';
import '../../features/workout/presentation/screens/workout_exercise_detail_screen.dart';
import '../../features/workout/presentation/screens/workout_summary_screen.dart';
import '../../core/ui/privacy_webview.dart';

import '../auth/auth_provider.dart';
import '../navigation/main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (_, __) => const LoadingScreen(),
      ),

      ShellRoute(
        builder: (_, __, child) => MainNavigation(child: child),
        routes: [
          ...dashboardRoutes,

          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),

          GoRoute(
            path: '/privacy',
            builder: (_, __) => const PrivacyWebView(),
          ),

          GoRoute(
            path: '/workout',
            builder: (_, __) => const WorkoutRedirectScreen(),
            routes: [
              GoRoute(
                path: 'start',
                builder: (_, __) => const WorkoutStartScreen(),
              ),
              GoRoute(
                path: 'active',
                builder: (_, __) => const WorkoutActiveScreen(),
              ),
              GoRoute(
                path: 'exercise/:exerciseId',
                builder: (_, state) {
                  final id = state.pathParameters['exerciseId']!;
                  return WorkoutExerciseDetailScreen(exerciseId: id);
                },
              ),
              GoRoute(
                path: 'summary',
                builder: (_, __) => const SummaryScreen(),
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