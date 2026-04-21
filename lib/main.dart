import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/offline/sync_provider.dart';
import 'core/offline/sync_status_listener.dart';
import 'core/offline/sync_status_bar.dart';
import 'core/network/connectivity_provider.dart';
import 'core/settings/settings_controller.dart';

import 'features/workout/providers/motivation_listener.dart';
import 'features/workout/providers/sound_listener.dart';
import 'features/gamification/application/gamification_listener.dart';
import 'features/ai_coach/application/ai_listener.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(connectivityProvider);
      ref.read(syncEngineProvider).processQueue();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(motivationListenerProvider, (_, __) {})
      ..listen(soundListenerProvider, (_, __) {})
      ..listen(gamificationListenerProvider, (_, __) {})
      ..listen(aiListenerProvider, (_, __) {});

    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider);

    final theme =
    settings.lightMode ? AppTheme.lightTheme : AppTheme.darkTheme;

    return SyncStatusListener(
      child: MaterialApp.router(
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
            child: Column(
              children: [
                const SyncStatusBar(),
                Expanded(child: child!),
              ],
            ),
          );
        },
      ),
    );
  }
}