import '../../services/token_storage.dart';

class AuthService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null;
  }
}