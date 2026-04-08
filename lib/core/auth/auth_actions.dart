import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

class AuthActions {
  static void logout(WidgetRef ref, BuildContext context) {
    ref.read(authProvider.notifier).logout();
    context.go('/login');
  }
}