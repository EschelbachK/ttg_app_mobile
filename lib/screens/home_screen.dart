import 'package:flutter/material.dart';
import '../services/token_storage.dart';

class HomeScreen extends StatelessWidget {
  final TokenStorage tokenStorage = TokenStorage();

  HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await tokenStorage.clearTokens();

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text("Logout"),
        ),
      ),
    );
  }
}