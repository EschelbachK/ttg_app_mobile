import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';
import '../../../core/auth/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      title: 'Login',
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).login(
              accessToken: 'dev_access_token',
              refreshToken: 'dev_refresh_token',
            );
            context.go('/dashboard');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
