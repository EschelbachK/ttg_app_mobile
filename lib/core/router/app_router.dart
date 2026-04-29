import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/verify/verify_info_screen.dart';
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

import '../auth/auth_state_provider.dart';
import '../navigation/main_navigation_widget.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: _RouterRefresh(ref),

    routes: [
      GoRoute(
        path: '/loading',
        builder: (_, __) => const LoadingScreen(),
      ),

      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/verify-info',
        builder: (_, state) {
          final email = state.extra as String?;
          return VerifyInfoScreen(email: email);
        },
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/reset-password',
        builder: (_, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
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

      final isAuthRoute = loc.startsWith('/login') ||
          loc.startsWith('/register') ||
          loc.startsWith('/forgot-password') ||
          loc.startsWith('/reset-password') ||
          loc.startsWith('/verify-info');

      if (!loggedIn && !isAuthRoute && loc != '/loading') {
        return '/login';
      }

      if (loggedIn && isAuthRoute) {
        return '/dashboard';
      }

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