import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/login_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/loading_screen.dart';
import '../auth/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {

  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {

      final isLoggedIn = authState.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';
      final isLoading = state.matchedLocation == '/loading';

      if (!isLoggedIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/loading';
      }

      if (isLoggedIn && isLoading) {
        return null;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});