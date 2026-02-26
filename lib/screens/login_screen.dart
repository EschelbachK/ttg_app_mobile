import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/auth_response.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();

  Future<void> _testLogin() async {
    try {
      AuthResponse result =
      await _apiService.login("test@test.de", "123456");

      print("Access Token: ${result.accessToken}");
      print("Username: ${result.user.username}");
    } catch (e) {
      print("Login Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: _testLogin,
          child: const Text("Login Test"),
        ),
      ),
    );
  }
}