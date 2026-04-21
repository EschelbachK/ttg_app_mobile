class UserModel {
  final String id;
  final String email;
  final String username;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
    );
  }
}