import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/loading_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';

import '../auth/auth_provider.dart';
import '../navigation/main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(

    initialLocation: '/loading',

    routes: [

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
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
            builder: (context, state) => const DashboardScreen(),
          ),

        ],
      ),
    ],

    redirect: (context, state) {

      final auth = ref.read(authProvider);
      final loggedIn = auth.isLoggedIn;

      final loggingIn = state.uri.toString() == '/login';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        return '/dashboard';
      }

      return null;
    },
  );
});