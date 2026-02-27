import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../services/api_service.dart';
import '../core/auth/auth_provider.dart';
import '../core/error/api_exceptions.dart';
import '../models/auth_response.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);

      final AuthResponse result = await apiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Auth-State setzen
      ref.read(authProvider.notifier).login();

      if (mounted) {
        context.go('/loading');
      }
    }

    on DioException catch (e) {
      final error = e.error;

      if (error is UnauthorizedException) {
        _errorMessage = "Invalid credentials.";
      } else if (error is NetworkException) {
        _errorMessage = "Network error. Please try again.";
      } else if (error is ServerException) {
        _errorMessage = "Server error. Please try later.";
      } else if (error is ApiException) {
        _errorMessage = error.message;
      } else {
        _errorMessage =
            e.response?.data?.toString() ??
                e.message ??
                "Unexpected error.";
      }

      setState(() {});
    } catch (_) {
      setState(() {
        _errorMessage = "Unexpected error.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                ),
              ],
            ),
          ),

          // Overlay falls bereits eingeloggt
          if (authState.isLoggedIn)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/dashboard');
                  },
                  child: const Text("Zum Dashboard"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}