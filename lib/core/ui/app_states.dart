import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class AppErrorView extends StatelessWidget {
  final String message;
  const AppErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(message, style: const TextStyle(color: Colors.red)));
}

class AppEmptyView extends StatelessWidget {
  final String message;
  const AppEmptyView({super.key, required this.message});

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(message, style: const TextStyle(color: Colors.white70)));
}