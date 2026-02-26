import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/auth_response.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }
}