import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  AuthNotifier() : super(const AuthState(isLoggedIn: false));

  void login({
    required String accessToken,
    required String refreshToken,
  }) {
    state = AuthState(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  void logout() {
    state = const AuthState(isLoggedIn: false);
  }

  Future<void> refreshToken() async {
    final token = state.refreshToken;
    if (token == null) return;

    await Future.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      accessToken: 'refreshed_access_token',
      isLoggedIn: true,
    );
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
