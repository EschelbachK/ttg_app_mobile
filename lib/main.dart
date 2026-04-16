import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/workout/providers/motivation_listener.dart';
import 'features/gamification/application/gamification_listener.dart';
import 'features/ai_coach/application/ai_listener.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(motivationListenerProvider);
    ref.watch(gamificationListenerProvider);
    ref.watch(aiListenerProvider);

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'TrainToGain',
      theme: AppTheme.darkTheme,
    );
  }
}