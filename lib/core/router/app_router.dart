import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/screens/loading_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/workout/screens/training_folders_screen.dart';
import '../auth/auth_provider.dart';
import '../navigation/main_navigation.dart';
import '../../features/auth/screens/login_screen.dart' as screens;

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const screens.LoginScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
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
            builder: (context, state) =>
            const TrainingFoldersScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loggedIn = auth.isLoggedIn;

      final location = state.uri.toString();
      final loggingIn = location == '/login';
      final loading = location == '/loading';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && (loggingIn || loading)) {
        return '/dashboard';
      }

      return null;
    },
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref ref;
}