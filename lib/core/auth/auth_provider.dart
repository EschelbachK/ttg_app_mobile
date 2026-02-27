import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/token_storage.dart';
import 'auth_service.dart';

class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenStorage _tokenStorage = TokenStorage();
  final AuthService _authService = AuthService();

  AuthNotifier() : super(const AuthState(isLoggedIn: false)) {
    _initialize();
  }

  Future<void> _initialize() async {
    final token = await _tokenStorage.getAccessToken();
    state = AuthState(isLoggedIn: token != null);
  }

  Future<void> login() async {
    state = const AuthState(isLoggedIn: true);
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    state = const AuthState(isLoggedIn: false);
  }

  // 🔥 HINZUGEFÜGT
  Future<void> refreshToken() async {
    final refreshToken =
    await _tokenStorage.getRefreshToken();

    if (refreshToken == null) {
      await logout();
      return;
    }

    try {
      final newTokens =
      await _authService.refresh(refreshToken);

      await _tokenStorage.saveTokens(
        newTokens.accessToken,
        newTokens.refreshToken,
      );

      state = const AuthState(isLoggedIn: true);
    } catch (_) {
      await logout();
    }
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);