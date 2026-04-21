import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return AuthResponse(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
      user: UserModel.fromJson(data['user']),
    );
  }
}