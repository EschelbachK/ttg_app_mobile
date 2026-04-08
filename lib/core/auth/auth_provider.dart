import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/token_storage.dart';
import '../../features/auth/models/auth_response.dart';
import 'auth_service.dart';

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

  AuthNotifier(this.ref) : super(const AuthState(isLoggedIn: false));

  Future<void> login(String email, String password) async {
    final res = await ref.read(authServiceProvider).login(email, password);

    final storage = ref.read(tokenStorageProvider);
    await storage.saveAccessToken(res.accessToken);
    await storage.saveRefreshToken(res.refreshToken);

    state = AuthState(
      isLoggedIn: true,
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
    );
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AuthState(isLoggedIn: false);
  }

  Future<void> refreshToken() async {
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.getRefreshToken();
    if (token == null) return;

    final res = await ref.read(authServiceProvider).refresh(token);

    await storage.saveAccessToken(res.accessToken);

    state = state.copyWith(
      accessToken: res.accessToken,
      isLoggedIn: true,
    );
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(ref),
);