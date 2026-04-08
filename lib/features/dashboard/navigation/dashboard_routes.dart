import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/dashboard_screen.dart';
import '../screens/muscle_group_screen.dart';
import '../screens/training_exercises_screen.dart';
import '../models/training_plan.dart';

List<RouteBase> dashboardRoutes = [
  GoRoute(
    path: '/dashboard',
    builder: (_, __) => const DashboardScreen(),
    routes: [
      GoRoute(
        path: 'muscle-group/:folderId',
        builder: (_, s) {
          final folderId = s.pathParameters['folderId'];
          final plan = s.extra as TrainingPlan?;
          if (folderId == null || plan == null) return const Scaffold(body: Center(child: Text('Routing Error')));
          return MuscleGroupScreen(folderId: folderId, plan: plan);
        },
      ),
      GoRoute(
        path: 'plans/:planId/folders/:folderId/exercises',
        builder: (_, s) {
          final folderId = s.pathParameters['folderId'];
          final planId = s.pathParameters['planId'];
          if (folderId == null || planId == null) return const Scaffold(body: Center(child: Text('Routing Error')));
          return TrainingExercisesScreen(folderId: folderId, planId: planId);
        },
      ),
    ],
  ),
];