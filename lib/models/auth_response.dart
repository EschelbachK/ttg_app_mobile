class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AuthResponse(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
      user: User.fromJson(data['user']),
    );
  }
}

class User {
  final String id;
  final String email;
  final String username;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
    );
  }
}