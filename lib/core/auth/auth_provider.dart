import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/state/active_plan_provider.dart';
import '../../services/token_storage.dart';
import '../network/dio_provider.dart';

class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    required this.isLoggedIn,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState(isLoggedIn: false)) {
    _init();
  }

  Future<void> _init() async {
    final storage = ref.read(tokenStorageProvider);
    final accessToken = await storage.getAccessToken();
    final refreshToken = await storage.getRefreshToken();

    if (accessToken != null && refreshToken != null) {
      state = AuthState(
        isLoggedIn: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }

  Future<void> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    final storage = ref.read(tokenStorageProvider);

    await storage.saveAccessToken(accessToken);
    await storage.saveRefreshToken(refreshToken);

    state = AuthState(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    ref.read(activePlanIdProvider.notifier).state = null;
  }

  Future<void> logout() async {
    final storage = ref.read(tokenStorageProvider);
    await storage.clear();

    state = const AuthState(isLoggedIn: false);
  }

  Future<void> refreshToken() async {
    final storage = ref.read(tokenStorageProvider);
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) return;

    final dio = ref.read(dioProvider);

    final response = await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    final newAccessToken = response.data['data']['accessToken'];

    await storage.saveAccessToken(newAccessToken);

    state = state.copyWith(
      accessToken: newAccessToken,
      isLoggedIn: true,
    );
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(ref),
);