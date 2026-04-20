import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/settings/application/settings_provider.dart';

import 'features/workout/providers/motivation_listener.dart';
import 'features/workout/providers/sound_listener.dart';
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
    ref
      ..listen(motivationListenerProvider, (_, __) {})
      ..listen(soundListenerProvider, (_, __) {})
      ..listen(gamificationListenerProvider, (_, __) {})
      ..listen(aiListenerProvider, (_, __) {});

    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider);

    final theme = settings.lightMode
        ? AppTheme.lightTheme
        : AppTheme.darkTheme;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'TrainToGain',
      theme: theme,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(settings.fontScale),
          ),
          child: child!,
        );
      },
    );
  }
}