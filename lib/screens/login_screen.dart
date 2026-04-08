import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/core/error/api_exceptions.dart';
import 'package:ttg_app_mobile/core/auth/auth_provider.dart';
import 'package:ttg_app_mobile/services/token_storage.dart';
import 'package:ttg_app_mobile/core/auth/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenStorage = TokenStorage();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      final result = await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      await _tokenStorage.saveTokens(
        result.accessToken,
        result.refreshToken,
      );

      ref.read(authProvider.notifier).login(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
    } on UnauthorizedException {
      setState(() => _errorMessage = "Invalid credentials.");
    } on NetworkException {
      setState(() => _errorMessage = "Network error. Please try again.");
    } on ServerException {
      setState(() => _errorMessage = "Server error. Please try later.");
    } catch (_) {
      setState(() => _errorMessage = "Unexpected error.");
    } finally {
      setState(() => _isLoading = false);
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
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}