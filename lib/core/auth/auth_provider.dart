import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/token_storage.dart';

class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenStorage _tokenStorage = TokenStorage();

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
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);