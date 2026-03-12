import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';
import '../navigation/main_navigation.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/loading_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/workout/screens/training_folders_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/loading',

    routes: [
      // ========= AUTH =========
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),

      // ========= APP SHELL =========
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/workout',
            builder: (context, state) => const TrainingFoldersScreen(),
          ),
        ],
      ),
    ],

    // ========= AUTH REDIRECT =========
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loggedIn = auth.isLoggedIn;

      final location = state.matchedLocation;
      final isLogin = location == '/login';
      final isLoading = location == '/loading';

      // Not logged in → always login
      if (!loggedIn && !isLogin) return '/login';

      // Logged in → skip login/loading
      if (loggedIn && (isLogin || isLoading)) return '/dashboard';

      return null;
    },
  );

  // Router refresh bei Auth-Änderung
  ref.listen(authProvider, (_, __) {
    router.refresh();
  });

  return router;
});